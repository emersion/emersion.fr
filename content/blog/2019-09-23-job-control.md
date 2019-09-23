+++
date = "2019-09-23T00:00:00+03:00"
title = "How does job control work?"
slug = "job-control"
lang = "en"
tags = ["shell"]
+++

Do you often use multiple programs at a single terminal? For instance, I
typically stop my text editor with Ctrl+Z to return to the shell and compile my
project. If compilation fails, I can go back to my text editor with `fg` to
make some changes. Perhaps you also use `bg` to continue a command in the
background, leaving the shell in the foreground. Many shell scripts append `&`
at the end of a command to start it in the background.

Job control is the mechanism behind all of these use-cases.

## But what is job control?

Each time I start a command from my shell, a job is created. For instance, if I
type `ls | grep asdf`, the shell creates one job with two processes inside:
`ls` and `grep asdf`.

As a shell user, I want to manipulate jobs, not processes. If I type Ctrl+C
during a job's execution, I want all processes belonging to the job to receive
a `SIGINT` signal to ask them to exit. If I type Ctrl+Z, I want all processes
to get stopped.

Also, when I have multiple jobs running at the same time, I want my key presses
to go to the _foreground job_. If I have `dd` running in the background and my
text editor running in the foreground, I want to type in my text editor. The
job which will receive input events has _exclusive access_ to my terminal.

In short, job control solves two problems:

* Multiple processes need to be manipulated at once (jobs)
* The shell needs to decide which job has exclusive access to the terminal (the
  foreground job)

## The shell's toolbelt

To implement job control, the shell has several tools at its disposal:

* [`waitpid`][waitpid]: this function can collect child processes' status. From
  this, the shell can figure out whether a child has terminated or has been
  stopped.
* We want all processes in a job to receive `SIGINT` when Ctrl+C is pressed. To
  achieve this, we need to put all processes belonging to a job in the same
  _process group_. [`setpgid`][setpgid] can be used for this.
* We want a single job to have exclusive access to the terminal.
  [`tcsetpgrp`][tcsetpgrp] allows the shell to tell which process group has
  control over the terminal.
* Processes can change some attributes of the terminal, for instance whether
  characters typed in the terminal are echoed. [`tcgetattr`][tcgetattr] can be
  used to get the current attributes and [`tcsetattr`][tcsetattr] can be used
  to set them.

[waitpid]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/waitpid.html
[setpgid]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/setpgid.html
[tcsetpgrp]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/tcsetpgrp.html
[tcgetattr]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/tcgetattr.html
[tcsetattr]: https://pubs.opengroup.org/onlinepubs/9699919799/functions/tcsetattr.html

## Putting it all together

### Starting a job

When starting a job, the shell first `fork`s and then `exec`s each program.
Error handling left out for brevity:

```c
void launch_process(char *argv[]) {
	pid_t pid = fork();
	if (pid == 0) {
		// This is the child
		execvp(argv[0], argv);
	}
	// This is the parent
}
```

We'll need to do two things: put the child process in its own process group and
give it control over the terminal. We only want to do the latter if we're
starting a foreground job (e.g. *not* when running `ls &`).

To create a new process group, we can set the process group of a process to its
own PID.

```c
void launch_process(char *argv[], bool foreground) {
	pid_t pid = fork();
	if (pid == 0) {
		// Create a new process group
		pid_t pgid = getpid();
		setpgid(getpid(), pgid);
		// Give control over the terminal
		if (foreground) {
			tcsetpgrp(STDIN_FILENO, pgid);
		}

		execvp(argv[0], argv);
	}

	// Create a new process group
	pid_t pgid = pid;
	setpgid(pid, pgid);
	// Give control over the terminal
	if (foreground) {
		tcsetpgrp(STDIN_FILENO, pgid);
	}
}
```

Note that we call [`setpgid`][setpgid] and [`tcsetpgrp`][tcsetpgrp] both in the
parent and in the child with the same parameters: this prevents race conditions
where the parent thinks the process group has been created but the child hasn't
done so already.

However there is one issue with the `launch_process` function: if the shell
executes `ls | grep asdf`, this will start two processes, but each will be in
its own process group. We want both processes to share the same process group.
When running `ls`, we need to create a new process group, but when running
`grep` we want to put the new child process into `ls`'s process group. We'll
need to call `setpgid(grep_pid, ls_pgid)`.

To fix this issue, let's change the function to take a pointer to the process
group ID. The first time we call `launch_process`, `*pgid` will be zero and
it'll get updated with the newly created process group ID. Next time it gets
called, the new process will be put in the existing process group.

```c
void launch_process(char *argv[], pid_t *pgid, bool foreground) {
	pid_t pid = fork();
	if (pid == 0) {
		if (*pgid == 0) {
			*pgid = getpid();
		}
		setpgid(getpid(), *pgid);
		if (foreground) {
			tcsetpgrp(STDIN_FILENO, *pgid);
		}
		execvp(argv[0], argv);
	}

	if (*pgid == 0) {
		// This is the first process of the job, create a new process group
		*pgid = pid;
	}
	setpgid(pid, *pgid);
	if (foreground) {
		tcsetpgrp(STDIN_FILENO, *pgid);
	}
}
```

### Stopping a job

We get this one for free: when Ctrl+Z is pressed, the terminal will send
`SIGTSTP` (terminal stop) to the process group controlling it. This will stop
all processes in the job.

The shell still needs to figure out the job has been stopped. To do so, it can
call [`waitpid`][waitpid] with `WUNTRACED` and check the process' status with
`WIFSTOPPED`.

```c
int status;
pid_t pid = waitpid(-1, &status, WUNTRACED);
bool stopped = WIFSTOPPED(status);
```

In this case, the shell needs to get back control over the terminal (with
[`tcsetpgrp`][tcsetpgrp]).

Because child processes may have changed the terminal attributes, the shell
also needs to restore its own attributes (with [`tcsetattr`][tcsetattr]). Right
before doing that, it saves the current attributes (with
[`tcgetattr`][tcgetattr]): this will be useful if it needs to restore them when
putting the job in the foreground again.

```c
// Give back control to the shell
tcsetpgrp(STDIN_FILENO, shell_pgid);

// Save the job's terminal attributes
tcgetattr(STDIN_FILENO, &job_attrs);
// Restore the shell's terminal attributes
tcsetattr(STDIN_FILENO, TCSADRAIN, &shell_attrs);
```

### Putting a job in the foreground/background

To continue a job in the background, we just need to send `SIGCONT`. We don't
need to give control over the terminal (only the foreground job has it).

To continue a job in the foreground, we need to send `SIGCONT` and give control
over the terminal to the job's process group. We also need to restore the job's
saved terminal attributes with a [`tcsetattr`][tcsetattr] call.

### Complete shell

That's about it! With all these ingredients, we can bake a little shell.

The [GNU libc job control manual][gnu-job-control] describes how to write a
complete shell with job control support. I've put together a [runnable
version][minishell] if you're interested.

When I was working on adding job control support to my shell [mrsh], a pain
point was to figure out how to plug all of this new logic into the shell's
existing interpreter.

Additionally, job control can be a little bit tricky to debug because there are
no clear errors: when you do something wrong, things can continue to work as
expected until they become completely messed up later. For instance if your
shell starts randomly exiting for no reason, you probably gave control over the
terminal to a terminated process.

I hope this helps shedding some light on this somewhat obscure Unix feature.
Happy hacking!

[minishell]: https://git.sr.ht/~emersion/minishell
[gnu-job-control]: https://www.gnu.org/software/libc/manual/html_node/Implementing-a-Shell.html
[mrsh]: https://mrsh.sh
