+++
date = "2020-03-26T00:00:00+02:00"
title = "Wayland clipboard and drag & drop"
slug = "wayland-clipboard-drag-and-drop"
lang = "en"
tags = ["wayland"]
+++

Clipboard and drag & drop are arguably one of the most complicated parts of the
core Wayland protocol. They involve a lot of back-and-forth communication
between three processes: the application where some content has been copied,
the compositor, and the application where some content is being pasted. The
whole dance will be explained in this article. This is an advanced Wayland
topic, the article assumes that the reader is familiar with concepts such as
the registry and globals. The [Wayland Book] is a good introduction to these
concepts.

On Wayland, clipboard and drag & drop share the same data transfer primitives.
The data can be plain text, but can also be rich content such as images or
paths to files (e.g. in a file manager). MIME types are used to specify the
data type. Sometimes the data is available in multiple formats, for instance
text in a web browser can be retrieved as `text/plain` or `text/html`.

Clipboard and drag & drop are tied to a particular seat. This allows two
different users of the same Wayland session to copy-paste content without
interfering with each other.

To get access to the clipboard and drag & drop interfaces, clients can bind to
the `wl_data_device_manager`. We'll also need to bind to a seat (error handling
omitted for brevity):

```c
static struct wl_data_device_manager *data_device_manager = NULL;
static struct wl_seat *seat = NULL;

static void registry_handle_global(void *data, struct wl_registry *registry,
		uint32_t name, const char *interface, uint32_t version) {
	if (strcmp(interface, wl_data_device_manager_interface.name) == 0) {
		data_device_manager = wl_registry_bind(registry, name,
			&wl_data_device_manager_interface, 3);
	} else if (strcmp(interface, wl_seat_interface.name) == 0 && seat == NULL) {
		// We only bind to the first seat. Multi-seat support is an exercise
		// left to the reader.
		seat = wl_registry_bind(registry, name, &wl_seat_interface, 1);
	}
}
```

After binding, we'll need to create a `wl_data_device` object to interact with
the clipboard and drag & drop on a particular seat:

```c
struct wl_data_device *data_device =
	wl_data_device_manager_get_data_device(data_device_manager, seat);
```

Clipboard is less involved than drag & drop, so let's dive into clipboard
first.

## Clipboard

As the name implies, a copy-paste operation happens in two steps:

- The user copies some content. For instance, the user selects some text and
  presses <kbd>Ctrl</kbd> + <kbd>C</kbd>. The application notifies the
  compositor that new clipboard content is available. This application is the
  _source client_.
- The user pastes some content (possibly in another application), e.g. by
  pressing <kbd>Ctrl</kbd> + <kbd>V</kbd>. At this point, the _destination
  client_ asks the source to send the clipboard contents via a file descriptor.

### Source client

To copy some content, the source client first needs to create a
`wl_data_source` object:

```c
struct wl_data_source *source =
	wl_data_device_manager_create_data_source(data_device_manager);
// Setup a listener to receive wl_data_source events, more on this below
wl_data_source_add_listener(source, &data_source_listener, NULL);
// Advertise a few MIME types
wl_data_source_offer(source, "text/plain");
wl_data_source_offer(source, "text/html");
```

The source client needs to be the currently focused application. This prevents
background applications from unexpectedly changing the clipboard contents right
before the users pastes it. This also allows to gracefully handle race
conditions when two applications quickly send copy requests. The serial
received during the `wl_keyboard.enter` must be provided to set the selection:

```c
wl_data_device_set_selection(data_device, source, keyboard_enter_serial);
```

At this point, the copy is done! The source client now needs to wait for
another application to perform a paste operation. This will be signaled by the
compositor via the `wl_data_source.send` event. When another application
replaces the clipboard contents, a `wl_data_source.cancelled` event is sent.  A
real client would perform some clean-up operations upon receiving the event.

```c
static const char text[] = "**Hello Wayland clipboard!**";
static const char html[] = "<strong>Hello Wayland clipboard!</strong>";

static void data_source_handle_send(void *data, struct wl_data_source *source,
		const char *mime_type, int fd) {
	// An application wants to paste the clipboard contents
	if (strcmp(mime_type, "text/plain") == 0) {
		write(fd, text, strlen(text));
	} else if (strcmp(mime_type, "text/html") == 0) {
		write(fd, html, strlen(html));
	} else {
		fprintf(stderr,
			"Destination client requested unsupported MIME type: %s\n",
			mime_type);
	}
	close(fd);
}

static void data_source_handle_cancelled(void *data,
		struct wl_data_source *source) {
	// An application has replaced the clipboard contents
	wl_data_source_destroy(source);
}

static const struct wl_data_source_listener data_source_listener = {
	.send = data_source_handle_send,
	.cancelled = data_source_handle_cancelled,
};
```

Note that we're performing blocking write calls in `data_source_handle_send`.
This could potentially stall the Wayland event loop if we had more data to
write (overflowing the kernel buffer). A real client would perform non-blocking
writes instead.

### Destination client

The destination client needs to listen to `wl_data_device` events to keep track
of the current clipboard contents. The destination client will only receive
such events if it's focused. This prevents background applications from
arbitrarily reading the clipboard (which may contain sensitive data such as
passwords).

First, the destination client will receive a `wl_data_device.data_offer` event.
This event allows the compositor to introduce a new `wl_data_offer` object,
which is the destination client view of a `wl_data_source`. The destination
client will be able to inspect the offer and list the supported MIME types.

```c
static void data_offer_handle_offer(void *data, struct wl_data_offer *offer,
		const char *mime_type) {
	printf("Clipboard supports MIME type: %s\n", mime_type);
}

static const struct wl_data_offer_listener data_offer_listener = {
	.offer = data_offer_handle_offer,
};

static void data_device_handle_data_offer(void *data,
		struct wl_data_device *data_device, struct wl_data_offer *offer) {
	// An application has created a new data source
	wl_data_offer_add_listener(offer, &data_offer_listener, NULL);
}

static const struct wl_data_device_listener data_device_listener = {
	.data_offer = data_device_handle_data_offer,
};
```

Then, the destination client will receive a `wl_data_device.selection` event
with the `wl_data_offer` introduced earlier. This event means that the offer
represents the current clipboard contents. A NULL offer is used when the
clipboard is empty.

The client can then request to receive the clipboard data by sending a
`wl_data_offer.receive` request:

```c
static void data_device_handle_selection(void *data,
		struct wl_data_device *data_device, struct wl_data_offer *offer) {
	// An application has set the clipboard contents
	if (offer == NULL) {
		printf("Clipboard is empty\n");
		return;
	}

	int fds[2];
	pipe(fds);
	wl_data_offer_receive(offer, "text/plain", fds[1]);
	close(fds[1]);

	wl_display_roundtrip(display);

	// Read the clipboard contents and print it to the standard output.
	printf("Clipboard data:\n");
	while (true) {
		char buf[1024];
		ssize_t n = read(fds[0], buf, sizeof(buf));
		if (n <= 0) {
			break;
		}
		fwrite(buf, 1, n, stdout);
	}
	printf("\n");
	close(fds[0]);

	wl_data_offer_destroy(offer);
}

static const struct wl_data_device_listener data_device_listener = {
	// .data_offer is the same as before
	.selection = data_device_handle_selection,
};
```

The `wl_display_roundtrip` is required here because we perform blocking read
calls. We need to make sure our request is sent to the compositor, otherwise
the source client won't send any data. The blocking read calls stall the
Wayland event loop. A real client would perform non-blocking reads instead.

A complete clipboard client is available in the [`selection` branch of
hello-wayland][hello-wayland-selection].

## Drag & drop

A drag-and-drop operation is a bit more complicated:

- The user presses their pointer button to start dragging (for instance a file,
  some text or an image). A little icon shows up next to the cursor. The cursor
  changes to a grabbing hand image.
- The user moves the cursor around the screen. If the cursor is over an area
  which would accept a drop, the cursor changes to a hand with a little arrow
  (if dropping would move a file for instance) or a little plus sign (if
  dropping would copy a file for instance). Pressing a key on the keyboard
  might[^1] change the action (e.g. <kbd>Ctrl</kbd> to move, <kbd>Shift</kbd> to
  copy).
- The user releases the pointer button. This confirms the drag-and-drop
  operation if possible (and cancels it otherwise).

At any time, pressing <kbd>Esc</kbd> might cancel the drag-and-drop. At the
end of the drag-and-drop operation, the user might be asked whether they want
to perform a move or a copy operation.

### Source client

Just like clipboard, the source client starts by creating a `wl_data_source`
object. The client can also specify the actions it supports. For instance when
selected text is being dragged from a textbox, the text can either be moved or
copied.

```c
struct wl_data_source *source =
	wl_data_device_manager_create_data_source(data_device_manager);
wl_data_source_add_listener(source, &data_source_listener, NULL);
wl_data_source_offer(source, "text/plain");

wl_data_source_set_actions(source, WL_DATA_DEVICE_MANAGER_DND_ACTION_MOVE |
	WL_DATA_MANAGER_DND_ACTION_COPY);
```

To start a drag-and-drop operation, the source must have received a
`wl_pointer.button` event with the `WL_POINTER_BUTTON_STATE_PRESSED` state. The
surface and serial received with this event needs to be provided:

```c
struct wl_surface *icon = NULL;
wl_data_device_start_drag(data_device, source, origin, icon,
	pointer_button_serial);
```

The client can also optionally specify an `icon` surface. The compositor will
display this surface next to the cursor.

Next, the source client will listen to feedback provided by the destination
clients. As the user moves the cursor between surfaces, the compositor will
send `target` and `action` events:

```c
static void data_source_handle_target(void *data, struct wl_data_source *source,
		const char *mime_type) {
	if (mime_type != NULL) {
		printf("Destination would accept MIME type if dropped: %s\n", mime_type);
	} else {
		printf("Destination would reject if dropped\n");
	}
}

static enum wl_data_device_manager_dnd_action last_dnd_action =
	WL_DATA_DEVICE_MANAGER_DND_ACTION_NONE;

static void data_source_handle_action(void *data, struct wl_data_source *source,
		uint32_t dnd_action) {
	last_dnd_action = dnd_action;
	switch (dnd_action) {
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_MOVE:
		printf("Destination would perform a move action if dropped\n");
		break;
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY:
		printf("Destination would perform a copy action if dropped\n");
		break;
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_NONE:
		printf("Destination would reject the drag if dropped\n");
		break;
	}
}

static const struct wl_data_source_listener data_source_listener = {
	// .send and .cancelled are the same as the clipboard case
	.target = data_source_handle_target,
	.action = data_source_handle_action,
};
```

We save the last received action, as we'll need it in the next step. Next step
which is… handling the drop!

If a destination can potentially accept the drop, we'll receive a
`dnd_drop_performed` event. Then the destination will initiate
a data transfer, just like in the clipboard case. When the data transfer is
complete, we'll receive `dnd_finished`.

```c
static void data_source_handle_dnd_drop_performed(void *data,
		struct wl_data_source *source) {
	printf("Drop performed\n");
}

static void data_source_handle_dnd_finished(void *data,
		struct wl_data_source *source) {
	switch (last_dnd_action) {
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_MOVE:
		printf("Destination has accepted the drop with a move action\n");
		break;
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY:
		printf("Destination has accepted the drop with a copy action\n");
		break;
	}
}

static const struct wl_data_source_listener data_source_listener = {
	// .send, .cancelled, .target, .action are the same as before
	.dnd_drop_performed = data_source_handle_dnd_drop_performed,
	.dnd_finished = data_source_handle_dnd_finished,
};

```

Note that receiving `dnd_drop_performed` doesn't mean that the drop has been
accepted by the destination. When the user releases their pointer button, the
destination can still cancel the drag-and-drop operation (or negotiate the
final action, more on this later).

### Destination client

Like clipboard, the destination client needs to listen to
`wl_data_device.data_offer` events to handle new data offers. In addition to
the MIME types supported by the source, we'll also receive the set of available
actions.

```c
static void data_offer_handle_source_actions(void *data,
		struct wl_data_offer *offer, uint32_t actions) {
	if (actions & WL_DATA_DEVICE_MANAGER_DND_ACTION_MOVE) {
		printf("Drag supports the move action\n");
	}
	if (actions & WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY) {
		printf("Drag supports the copy action\n");
	}
}

static const struct wl_data_offer_listener data_offer_listener = {
	// .offer is the same as before
	.source_actions = data_offer_handle_source_actions,
};
```

When the user has initiated a drag-and-drop operation and moves the cursor over
one of the destination client's surfaces, a `wl_data_device.enter` event will
be sent by the compositor. As the user moves the cursor, `motion` events will
indicate the updated position of the cursor — this is important because
different regions of the surface may or may not accept drag-and-drop. When the
cursor leaves the surface, a `leave` event is sent.

As the user moves the cursor, the destination client needs to provide feedback
to the source client. To do so, the destination client must send
`wl_data_offer.set_actions` requests. If the cursor is over a region that
accepts drops, `supported_actions` is set a mask of supported actions.
Otherwise, it's set to zero.

```c
static void wl_data_offer *current_drag_offer = NULL;

static void data_device_handle_enter(void *data,
		struct wl_data_device *data_device, uint32_t serial,
		struct wl_surface *surface, wl_fixed_t x, wl_fixed_t y,
		struct wl_data_offer *offer) {
	printf("Drag entered our surface at %fx%f\n",
		wl_fixed_to_double(x), wl_fixed_to_double(y));

	current_drag_offer = offer;

	// We support the copy action if dropped anywhere on our surface
	uint32_t supported_actions = WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY;
	enum wl_data_device_manager_dnd_action preferred_action =
		WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY;
	wl_data_offer_set_actions(offer, supported_actions, preferred_action);
}

static void data_device_handle_motion(void *data,
		struct wl_data_device *data_device, uint32_t time,
		wl_fixed_t x, wl_fixed_t y) {
	// This space is intentionally left blank
}

static void data_device_handle_leave(void *data,
		struct wl_data_device *data_device) {
	printf("Drag left our surface\n");
	current_drag_offer = NULL;
}

static const struct wl_data_device_listener data_device_listener = {
	// .data_offer is the same as before
	.enter = data_device_handle_enter,
	.motion = data_device_handle_motion,
	.leave = data_device_handle_leave,
};
```

We'll also receive `wl_data_offer.action` events, which contains the action
that would be performed if a drop was performed. The compositor chooses this
action after intersecting the actions supported by the source and the
destination.

```c
static void data_offer_handle_action(void *data,
		struct wl_data_offer *offer, uint32_t dnd_action) {
	switch (dnd_action) {
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_MOVE:
		printf("A move action would be performed if dropped\n");
		break;
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_COPY:
		printf("A copy action would be performed if dropped\n");
		break;
	case WL_DATA_DEVICE_MANAGER_DND_ACTION_NONE:
		printf("The drag would be rejected if dropped\n");
		break;
	}
}

static const struct wl_data_offer_listener data_offer_listener = {
	// .offer and .source_actions are the same as before
	.action = data_offer_handle_action,
};
```

When the user releases the pointer button, we'll receive a
`wl_data_device.drop` event. We'll then be able to accept the drop by sending
a `wl_data_offer.accept` request, then performing the data transfer as usual.
Once we're done with the drop, we must send a `finish` request and destroy it.
If we want to reject the drop, we can just destroy the offer before sending an
`accept` request.

```c
static void data_device_handle_drop(void *data,
		struct wl_data_device *data_device) {
	assert(current_drag_offer != NULL);

	wl_data_offer_accept(current_drag_offer, "text/plain");

	int fds[2];
	pipe(fds);
	wl_data_offer_receive(offer, "text/plain", fds[1]);
	close(fds[1]);

	// TODO: do something with fds[0]
	close(fds[0]);

	wl_data_offer_finish(current_drag_offer);
	wl_data_offer_destroy(current_drag_offer);
	current_drag_offer = NULL;
}

static const struct wl_data_device_listener data_device_listener = {
	// .data_offer, .enter, .motion and .leave are the same as before
	.drop = data_device_handle_drop,
};
```

With this last piece of the puzzle, we've successfully handled the drop!

Note that we've only used the "move" and "copy" actions here. If we wanted to
ask the user whether they want to perform a move or a copy operation, we
would've added `WL_DATA_DEVICE_MANAGER_DND_ACTION_ASK` to our supported
actions. In `data_device_handle_drop`, if the last received
`wl_data_offer.action` was "ask", we would've presented a selection UI to the
user, then sent a `wl_data_offer.set_actions` request with the final action.

## Other related APIs

So far we've talked about the clipboard and drag & drop interfaces exposed in
the core Wayland protocol. There are also related interfaces exposed in other
protocols which enable extra features.

Some users rely on the "primary selection" feature of X11 — select some text,
then paste it in any other client by pressing the middle mouse button. This is
implemented on Wayland via an interface very similar to `wl_data_device` in the
[`primary-selection` protocol][primary-selection].

Some clients want more control over the clipboard: for instance password
managers want to store passwords to allow the user to easily paste them in any
client, and password managers want to keep track of the whole clipboard
history. wlroots has a special privileged protocol called
[`wlr-data-control`][wlr-data-control] for these use-cases. Naturally regular
clients must not depend on this protocol.

I hope this article helped getting a better understanding of these Wayland
interfaces. The raw protocol can be intimidating and it's hard to understand
in which order requests and events are sent when there are so many
interactions. As always, let me know if you spot mistakes or if you have
questions!

[^1]: "Might" means that this is compositor-specific behavior: the compositor can choose to implement this feature, or can choose not to.

[Wayland Book]: https://wayland-book.com/
[hello-wayland-selection]: https://github.com/emersion/hello-wayland/tree/selection
[primary-selection]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/blob/master/unstable/primary-selection/primary-selection-unstable-v1.xml
[wlr-data-control]: https://github.com/swaywm/wlr-protocols/blob/master/unstable/wlr-data-control-unstable-v1.xml
