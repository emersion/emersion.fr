+++
date = "2017-06-09T00:00:00+02:00"
title = "Flattening a graph into a sequence"
lang = "en"
+++

During my internship at [LRI](https://www.lri.fr), I had to flatten a graph into
a sequence. The resulting algorithm isn't complicated, but I found the several
appoaches before ending up with a fully working solution pretty interesting.

More precisely, the graph is
[directed and acyclic](https://en.wikipedia.org/wiki/Directed_acyclic_graph)
(DAG). The graph's vertices represent steps, and an arrow from A to B means that
the step A happens before B.

```
                                                                +-------+
                                                                |       |
                                                            +-->|   f   +--+
                                                            |   |       |  |
                                +-------+                   |   +-------+  |
                                |       |                   |              |
                            +-->|   c   +--+                |              |
                            |   |       |  |                |              |
+-------+       +-------+   |   +-------+  |    +-------+   |   +-------+  |    +-------+
|       |       |       |   |              |    |       |   |   |       |  |    |       |
|   a   +------>|   b   +---+              +--->|   e   +---+-->|   g   +--+--->|   i   +
|       |       |       |   |              |    |       |   |   |       |  |    |       |
+-------+       +-------+   |   +-------+  |    +-------+   |   +-------+  |    +-------+
                            |   |       |  |                |              |
                            +-->|   d   +--+                |              |
                                |       |                   |              |
                                +-------+                   |   +-------+  |
                                                            |   |       |  |
                                                            +-->|   h   +--+
                                                                |       |
                                                                +-------+
```

The aim is to transform the graph into a sequence. A sequence is a list of
itemsets. Here, an itemset is a set of steps that happen at the same time.
Itemsets are noted between parentheses. For instance, the graph above would be
represented as:

```
<ab(cd)e(fgh)i>
```

We can store a sequence using a list of sets:

```python
seq = [
	{'a'},
	{'b'},
	{'c', 'd'},
	{'e'},
	{'f', 'g', 'h'},
	{'i'}
]
```

## First attempt: simple BFS

The first idea that came to my mind was to find the heads of the graph and then
perform a simple [BFS](https://en.wikipedia.org/wiki/Breadth-first_search).

The BFS is a little bit more complicated than a vanilla BFS: we need to organize
items in levels. Level 0 contains all heads, level 1 contains all children of
all heads, and so on. To do so, we can use two variables `queueLen` and
`nextQueueLen` to keep track of the number of items in the queue that belong to
the current level and to the next level.

Pseudo-code:

```python
# Find heads
heads <- Set(G.nodes)
for n in G.nodes:
	for s in G.successors(n):
		heads.remove(s)

seq <- []
itemset <- Set()

# Create a queue containing all heads (level 0)
queue <- Queue(heads)
queueLen <- len(heads)
nextQueueLen <- 0
while queue is not empty:
	n <- queue.shift()
	queueLen--

	itemset.add(n)

	# Push all successors to the queue
	for s in G.successors(n):
		queue.push(s)
		nextQueueLen++

	# When we're done processing this level, create a fresh itemset
	if queueLen = 0:
		seq.append(itemset)
		itemset <- Set()
		queueLen <- nextQueueLen
		nextQueueLen <- 0
seq.append(itemset)

return seq
```

The complexity of this solution is _O(n)_, with _n_ the number of nodes.

That works well with
[trees](https://en.wikipedia.org/wiki/Tree_(data_structure)),
but not for graphs in general. The graph below would have been translated to
`<(ac)(bd)d>` instead of `<a(bc)d>`:

```
+-------+      +-------+
|       |      |       |
|   a   +----->|   b   +--+
|       |      |       |  |
+-------+      +-------+  |   +-------+
                          |   |       |
                          +-->|   d   +
                          |   |       |
               +-------+  |   +-------+
               |       |  |
               |   c   +--+
               |       |
               +-------+
```

## Second attempt: traversing in all directions

To overcome the first approach's issues, I decided to solve the problem
differently. Instead of doing a BFS, I tried to choose a random node in the
graph, and visit recursively its successors _and_ its anscestors.

We can arbitrarily choose that the random node is at level 0, its successors
are at level 1 and its anscestors are at level -1. We can recursively compute
each node's level.

After that, we just need to group nodes by level, and list them in the correct
order.

Pseudo-code:

```python
levels <- Dict()

def process_node(node, level):
	if node in levels:
		return # Already explored
	levels[node] <- level

	for s in G.successors(node):
		process_node(s, level + 1)
	for a in G.anscestors(node):
		process_node(a, level - 1)

# Traverse the whole graph
process_node(random_node, 0)

# Sort nodes by level
sort(G.nodes, levels)

# Build a sequence from levels
seq <- []
itemset <- Set()
level <- None
for n in G.nodes:
	if levels[n] != level:
		seq.append(itemset)
		itemset <- Set()

	itemset.add(n)
seq.append(itemset)
```

The complexity of this solution is _O(n . ln n)_, because of the `sort`
operation.

I tried the first solution before this one because the latter requires to be
able to list a node's anscestors. Depending of how your graph is represented in
memory, you may need to do some kind of preprocessing to build a list of
anscestors for each node (that was my case). The overhead of this operation is
in _O(n)_.

But this algorithm has still one problem: it doesn't handle well forks having
a different number of nodes. For instance, the graph below is flattened to
`<ab(cd)(ef)f>` instead of `<ab(cd)ef>`:

```
                              +-------+      +-------+
                              |       |      |       |
                          +-->|   c   +----->|   e   +--+
                          |   |       |      |       |  |
+-------+      +-------+  |   +-------+      +-------+  |   +-------+
|       |      |       |  |                             |   |       |
|   a   +----->|   b   +--+                             +-->|   f   +
|       |      |       |  |                             |   |       |
+-------+      +-------+  |   +-------+                 |   +-------+
                          |   |       |                 |
                          +-->|   d   +-----------------+
                              |       |
                              +-------+
```

## Third attempt: overwriting

It's possible to solve the second solution's issues by modifying the
`process_node` function a bit. The current function stops if the node has
already been processed (`if node in levels`).

From the example above, two cases can be considered:

1. From `b`, the recursive function has first processed `d`, `f` and then has
	processed `c`, `e`, `f`.
2. From `f`, the recursive function has first processed `d`, `b`, `a` and then
	has processed `e`, `c`, `b`, `a`.

In case (1), we can just re-process a node if we've found a level greater than
the current one. We'll do that only when we're traversing the graph forwards. In
case (2), we can do the same thing: when we're traversing the graph backwards,
re-process a node if we've found a level lower than the current one.

Here is the modified function:

```python
def process_node(node, last_level, level):
	if node in levels:
		if levels[node] = level:
			return
		if last_level < level && last_level < levels[node]:
			return
		if last_level > level && last_level > levels[node]:
			return
	levels[node] <- level

	for s in G.successors(node):
		process_node(s, level, level + 1)
	for a in G.anscestors(node):
		process_node(a, level, level - 1)
```

The recursive call terminates if the graph is acyclic, because the level is
bounded and can only either increase or decrease, depending of its position
relative to the first random node.

The recursive call can be rewritten with an explicit stack to process large
graphs and for improved performance.

The worst case complexity of this solution is _O(n²)_ because a node can be
processed at most _n/2_ times.

## Conclusion

We've seen three different solutions, which can be used respectively with trees,
DAGs without asymmetric forks, and DAGs in general.

If you find a better solution, make sure to drop me a line!
