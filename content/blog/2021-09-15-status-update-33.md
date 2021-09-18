+++
date = "2021-09-15T00:00:00+02:00"
title = "Status update, September 2021"
slug = "status-update-33"
lang = "en"
tags = ["status update"]
+++

Hi all!

As often, my main focus this month has been Wayland-related stuff. The biggest
new item is likely the introduction of a [scene-graph API][wlr-scene] to
wlroots. With this new API, compositors can organize the objects which will be
rendered on-screen in a tree. Surfaces, buffers, and solid-color rectangles are
nodes in the scene-graph. Compositors can arrange the nodes, enable or disable
them and set their position. The API is limited to basic 2D operations (much
like KMS), for anything more complicated compositors can (permanently or
temporarily) use custom rendering logic.

This is a great data structure, because it allows wlroots to provide features
and optimizations for free™. For instance, the scene-graph can handle damage
tracking without the compositor caring about it. The scene-graph can also be
integrated with other wlroots APIs, for instance `wlr_output_layout` to sync
the position of the outputs in the scene or `wlr_subsurface` to show a whole
surface tree in the scene. I think the scene-graph has the potential to make it
a lot easier to write efficient wlroots-based compositors, without sacrificing
customizability!

Also worth mentioning is Vyivel's work on wlroots' surface state API. He's been
fixing a lot of subtle bugs and improving significantly how this part of
wlroots works internally. Thanks!

I've also contributed a lot to [gamescope], Valve's gaming compositor. This is
going to be used on the upcoming Steam Deck, even if it's not limited to that
and can be useful on any gaming PC as well. gamescope now has better
multi-output support and an indirection through EGL has been dropped. I'm now
working on getting KMS planes to work reliably on amdgpu and adding virtual
keyboard support.

Valve sent me a prototype to develop and test on, and I'm very impressed! Since
it's just a regular PC, you can make it run whatever you want on it. Mandatory
Sway picture:

![sway on steam deck]

In other Wayland news, thanks to the efforts of Peter Hutterer, Daniel Stone,
Derek Foreman and Alexander Richardson, libwayland now has upstream support for
FreeBSD! This involved a lot of work, especially to allow FreeDesktop's GitLab
CI to run the test suite on FreeBSD. It's great to see non-Linux platforms
getting proper support and not needing to constantly rebase custom patches.

I've also been working on improving the IRC ecosystem. [soju 0.2.0] has been
released, adding a new IRC extension to better integrate clients with the
bouncer's multi-network functionality. [gamja] has improved chat history
support and makes use of the MONITOR extension to indicate the status of the
remote user when chatting in private. I've been experimenting with a [new
extension for push notifications][ircv3-webpush], allowing to build better
Web and Android clients especially on mobile devices. Discussed in the proposal
is the integration with proprietary push services, which I don't use nor like
but I think is important to push the standardization effort forward. In the
future, I'd like to continue this effort by enabling push notifications on
Android devices without Google Play Services (either by adding a new Android
service which integrates with an existing open-source push service like
Mozilla's, or by building an open-source clone of Firebase Cloud Messaging and
using it with MicroG).

That's all for now, see you next month!

[wlr-scene]: https://github.com/swaywm/wlroots/issues/1826
[gamescope]: https://github.com/Plagman/gamescope
[sway on steam deck]: https://l.sr.ht/pG21.jpg
[soju 0.2.0]: https://git.sr.ht/~emersion/soju/refs/v0.2.0
[gamja]: https://sr.ht/~emersion/gamja/
[ircv3-webpush]: https://github.com/ircv3/ircv3-specifications/pull/471
