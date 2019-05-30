+++
date = "2019-05-30T00:00:00+03:00"
title = "Introduction to damage tracking"
slug = "intro-to-damage-tracking"
lang = "en"
tags = ["wayland"]
+++

One year and a half ago, I implemented damage tracking for [wlroots]. It's about
time I write an article about it!

I'll explain damage tracking in the context of a Wayland compositor, but most of
that should also apply to other things-that-render-stuff as well.

# What is damage tracking?

The compositor's mission is simple: take a bunch of pixel buffers from clients
(e.g. your web browser's window or your text editor's), draw them together on a
larger buffer and display the larger buffer on your screen.

When you're writing a Wayland compositor for the first time, you start by doing
that 60 times per second. This works well, but after a while you notice that
your compositor is doing more work than necessary: often times the screen stays
perfectly screen, nothing changes. In the case of a Wayland compositor, this
happens when none of the clients update its buffers.

Level zero of damage tracking is noticing when nothing changes and stopping
rendering. Of course as soon as a client updates its buffer you need to start
rendering again.

![Render loop pause example](https://sr.ht/Dv0J.svg)

In this example, first client A submits updates, then client B also submits
updates: during this whole time the compositor needs to draw new frames. But
then both stop, so the compositor can have a nap. When client B starts drawing
again, the compositor needs to wake up.

Once you've implemented this, your compositor is already way cooler (or maybe
your laptop is, since you don't waste cycles rendering useless frames anymore).
However you notice that when the screen is updated, often only a very small
region of the screen changes. For instance, when writing some text only the
places where the new characters appear actually change.

And that's what damage tracking is all about: we want to avoid rendering regions
of the screen that haven't changed. When clients submit a new buffer, they also
indicate which parts of the frame changed. Our goal is to use this information
to redraw as little as possible.

Here's an example with `htop`: only the parts that have changed are rendered,
the regions that don't changed are painted in yellow.

<video src="https://sr.ht/fs1u.mp4" controls>

We can see that elements such as the window titlebar and the table header are
still. When moving You can try it yourself by building wlroots and running
`rootston -D`.

# Multiple buffering

Now, one may think "I just need not to render those regions and it will just
work, right?". However reality is more complicated.

When we render, it's very likely that we don't draw to the same buffer each
time. This is due to multiple buffering[^1].

If there were only one buffer, we would be drawing to the buffer that's
currently being displayed on the screen. That's Bad™ because this will lead to
displaying half-rendered frames, which leads to flickering, which leads to your
eyes bleeding.

To prevent this scourge, one buffer is used for rendering and a separate one for
display. When we're done drawing, we "swap buffers" — the rendering buffer
becomes the display buffer and the other way around. Here's an example with the
buffer swap in green:

![Double buffering](https://sr.ht/BwFL.svg)

Initially the screen is blank. Then we draw a single heart on our render buffer.
To display it, we swap buffers. While the single heart is visible, we draw two
hearts on our render buffer. On the next buffer swap, these two hearts will be
displayed on screen.

It's important to keep in mind that buffers go back-and-forth between the
rendering stage and the display stage. The first buffer we draw on becomes the
display buffer after the first swap, and then goes back to being the render
buffer after the second swap.

# Frame damage vs. buffer damage

If we look at what changed from the first displayed frame to the second one in
the previous example, we notice one heart is added at each buffer swap. However
if we look at what changed on a particular buffer each time we draw, we notice
two hearts are added each time (follow the green arrows going up).

Let's re-order things a little to better understand what's going on. In the
following image, the render buffer has a green border.

![Buffer damage](https://sr.ht/gj7o.svg)

We can only draw to render buffers (ie. those having black borders). After each
buffer swap we draw 2 new hearts to the render buffer. It's not enough to just
draw what changed since the last displayed frame!

Thus we have to deal with two kinds of damage:

* **Frame damage**: this is what changes from one frame to the next one[^2].
  This is also what clients give us when submitting a new buffer.
* **Buffer damage**: this is what we need to redraw when re-using an old buffer.

![Buffer damage vs. frame damage](https://sr.ht/wLle.svg)

# Buffer age

When using EGL for rendering, we don't handle the buffers manually: they are
automatically managed by EGL. That means it's not clear on which buffer we're
drawing: it could be a fresh buffer or an old buffer that is re-used.

Fortunately, an extension named [`EGL_EXT_buffer_age`][EGL_EXT_buffer_age]
allows us to query the "age" of the buffer. In the case of double buffering (as
in the examples) the age will be 2: each time we draw we re-use a buffer that
we've drawn to 2 frames ago.

In order to compute buffer damage, we need to accumulate frame damage from
one or more previous frames. In the example above we need to add the current
frame damage and the previous one to get the current buffer damage. In the
case of triple buffering we'd need to add the current frame damage and the
last 2 previous frame damage.

All right, now that we have the buffer damage we know exactly which region we
need to redraw!

# When, how, what to damage

As we've seen, when rendering a new frame we need access to the current frame
damage, aka. what changed since the last frame. That means that between two
frames, we need to accumulate pending frame damage for the next frame. It may
not be immediately clear what events should expand the pending frame damage,
so here are a few common cases:

* When a client submits a new frame (the technical term is _commit_): we need to
  add the client's surface damage to our pending frame damage.
* When a client creates a new surface on screen or destroys it (the technical
  term is _map_ or _unmap_ a surface): we need to damage the whole surface.
* When we change a surface's position or size (e.g. when moving and resizing):
  we need to damage the previous position/size *and* the new one. If we only
  damage the new position/size then the last frame at the previous position/size
  will remain. In general the idea is: damage, do the thing, damage again.

Note that since we're writing a compositor, our damage is per-output, so
whenever we accumulate damage from a surface we need offset it by the surface's
coordinates. Additionally, on Wayland the surfaces are organized in a tree, so
one needs to walk up the tree to compute the surface's position relative to an
output.

# The Swiss Cheese Problem

Sometimes our damage can look like a Swiss cheese: lots of small rectangles.
Thus when rendering we'd send lots of small draw operations to the GPU. This
generally decreases performance, and it would even be faster to just disable
damage tracking and redraw the whole thing.

For this reason it's generally a good idea to simplify the damage if it gets too
complicated[^3]. Simplifying can be done by computing the region's extents (so
many small rectangles end up being one big rectangle) if the number of
rectangles is too high. This is probably not the best way to do it, it would be
interesting to experiment and benchmark other possible solutions.

# HiDPI and transforms

HiDPI and transforms make things a little more involved because introducing more
coordinate systems become necessary. For instance, when a surface has a size of
100×200px, a scale of 2 and a transform of 90 degrees, the client will attach
buffers that have a size of 400×200px. Similarly, an output can be scaled and
transformed. Each time we get a coordinate or a region, we need to figure out in
which coordinate system it's expressed:

* Surface buffer-local coordinates: relative to the buffer attached by the
  client. In our example it's in a 400×200px rectangle relative to the top-left
  corner of the surface.
* Surface-local coordinates: unscaled, untransformed coordinates. In our example
  it's in a 100×200px rectangle relative to the top-left corner of the surface.
* Output buffer-local coordinates: inside the buffer attached to the output
  (ie. the buffer we render to).

Typically, when a client submits new frame the damage region will be converted
from surface buffer-local coordinates into surface-local coordinates, and then
into output buffer-local coordinates.

# The wlroots API

wlroots has a `wlr_output_damage` helper that computes buffer damage from frame
damage for you. You can accumulate damage from surfaces by listening to their
`commit` event, getting the surface-local frame damage with
`wlr_surface_get_effective_damage`, converting it into output-buffer-local
coordinates and then calling `wlr_output_damage_add`. When you need to render,
calling `wlr_output_damage_attach_render` will fill the buffer damage region
that you need to repaint. Right before swapping buffers with
`wlr_output_commit`, you can call `wlr_output_set_damage` with the frame damage
(not the buffer damage!) which is stored in `wlr_output_damage.current`.

And that's pretty much it!

[^1]: Generally double or triple buffering
[^2]: [`EGL_KHR_partial_update`][EGL_KHR_partial_update] uses the name "surface damage", but it's confusing when talking about Wayland compositors because surfaces already refer to objects created by clients. Thus wlroots uses the term "frame damage" instead.
[^3]: wlroots does it automatically for you

[wlroots]: https://github.com/swaywm/wlroots
[EGL_EXT_buffer_age]: https://www.khronos.org/registry/EGL/extensions/EXT/EGL_EXT_buffer_age.txt
[EGL_KHR_partial_update]: https://www.khronos.org/registry/EGL/extensions/KHR/EGL_KHR_partial_update.txt
