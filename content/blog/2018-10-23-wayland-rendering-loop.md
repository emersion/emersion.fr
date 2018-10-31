+++
date = "2018-10-23T00:00:00+02:00"
title = "Writing a Wayland rendering loop"
slug = "wayland-rendering-loop"
lang = "en"
tags = ["wayland"]
+++

When you're building a graphical program, you often need to use a rendering
loop. For instance for a Pacman game, you basically need to check if the user
has pressed keyboard keys, update the position of Pacman accordingly, and draw
a new frame.

## Refresh synchronization

Your typical rendering loop will look like this:

```c
while (true) {
	process_events(); // Process events, e.g. from keyboard

	glClear(GL_COLOR_BUFFER_BIT);
	draw(); // Draw nice things

	eglSwapBuffers(egl_display, egl_surface);
}
```

One could think that this is a busy loop: if you poll events and draw without
waiting then you'll consume 100% CPU. You'll also draw many unused frames, since
your monitor can only display frames at 60 Hz. Each time the monitor displays a
new frame, we say that a _refresh_ happens (also called _vsync_).

Fortunately, `eglSwapBuffers` will implicitly wait for the next monitor refresh.
That means that we're not drawing unnecessary frames, since we're only executing
one iteration of the loop 60 times a second.

## Let's not waste frames

That last sentence is only true when we're the focused window. This is the case
for many fullscreen games, but it's not true for all other apps.

First, on many compositors apps can be minimized (hidden in the "taskbar"). In
this case, we don't want to render any frame. Many programs do something like
this:

```c
while (true) {
	process_events();

	if (/* I'm minimized */) {
		continue;
	}

	glClear(GL_COLOR_BUFFER_BIT);
	draw();

	eglSwapBuffers(egl_display, egl_surface);
}
```

(For instance, if you're using GLFW you can check for `GLFW_ICONIFIED`)

However, this isn't enough. There are other situations in which a window is
hidden: if it's on another workspace, or if it's completely hidden behind other
opaque windows. Also, when you're minimized maybe the compositor actually wants
you to continue to render because it's displaying your window as a thumbnail.
Maybe the compositor wants you to render at 10FPS instead of 60FPS when you're a
thumbnail to save resources.

Clearly the approach of guessing when and how often you should render has its
limitations. Instead of exposing whether an application is minimized, on
another workspace or rendered as a thumbnail, Wayland has chosen a different
approach.

## Wayland's frame callback

The idea is quite simple: the compositor will tell you when to draw. That way
the compositor gains more flexibility, it can optimize compositing whether it
implements or not workspaces, minimization or whatever new window management
mechanism. Clients are simplified because they don't need to guess anymore, and
they never render useless frames.

And good news: `eglSwapBuffers` is already using it! When you call it, it
registers a frame callback and blocks until it is fired (ie. blocks until the
next time the app is supposed to render).

While this works well for fullscreen games and simple programs, you'll start
running into issues if your program is a little bit more complicated. Once your
app becomes hidden, it stops receiving frame events so it's completely blocked:
`eglSwapBuffers` will not return. If it's using the network, it'll just stop
receiving anything until it is visible again. If it handles copy-paste, you
won't be able to paste some text copied from an invisible window (pasting
requires the sender to write the clipboard's content to a file descriptor).
Additionally, it means you won't be able to receive input events (keyboard,
mouse) while you're waiting for a frame event.

So instead of using this default blocking behaviour, maybe you'll want _not_ to
block. This can be done by manually managing frame callbacks and calling
`eglSwapInterval(egl_display, 0)`.

Let's see how this works in practice. Prior to `eglSwapBuffers`, one can call
`wl_surface_frame`. This returns a callback that will be fired when the next
frame should be drawn.

Our main loop is now only:

```c
while (true) {
	// This will process all events, including frame events
	process_events();
}
```

When we want to draw, we'll register a frame callback.

```c
void render(void) {
	glClear(GL_COLOR_BUFFER_BIT);
	draw();

	// Make eglSwapBuffers non-blocking, we manage frame callbacks manually
	eglSwapInterval(egl_display, 0);

	// Register a frame callback to know when we need to draw the next frame
	struct wl_callback *callback = wl_surface_frame(surface);
	wl_callback_add_listener(callback, &frame_listener, NULL);

	// This call won't block
	eglSwapBuffers(egl_display, egl_surface);
}
```

Now we need to decide what to do when we get a frame event. In our case we just
want to render again:

```c
static void frame_handle_done(void *data, struct wl_callback *callback,
		uint32_t time) {
	wl_callback_destroy(callback);
	render();
}

const struct wl_callback_listener frame_listener = {
	.done = frame_handle_done,
};
```

That's it! A full example is available [in the `opengl-render-loop` branch of my
hello-wayland repo][hello-wayland-opengl].

### Further reading

* The [presentation-time protocol][presentation-time] for accurate presentation
  timing feedback
* [Discussion][pq-frame-ml] about ways to use the frame callback and
  presentation-time
* [Repaint scheduling on the compositor side][repaint-scheduling]

[hello-wayland-opengl]: https://github.com/emersion/hello-wayland/tree/opengl-render-loop
[presentation-time]: https://github.com/wayland-project/wayland-protocols/blob/master/stable/presentation-time/presentation-time.xml
[pq-frame-ml]: https://lists.freedesktop.org/archives/wayland-devel/2016-March/027465.html
[repaint-scheduling]: https://ppaalanen.blogspot.com/2015/02/weston-repaint-scheduling.html
