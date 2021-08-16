+++
date = "2021-08-16T00:00:00+02:00"
title = "Status update, August 2021"
slug = "status-update-32"
lang = "en"
tags = ["status update"]
+++

Hi all!

It may sound surprising, but this month again my main focus has been wlroots.
The main highlight is the completion of the "renderer v6" refactoring! All of
the internals have been adjusted. We can now slowly take advantage of its
flexibility. For instance, the [WIP Vulkan renderer][wlr-vk] requires exactly
zero changes to the backends (I still need to take some time to push it
forward!). As another example, the screen capture logic
[is getting simplified][wlr-screen-capture]. The completion of renderer v6 will
also help with [output layers][wlr-output-layers] and [libliftoff] integration.

A big remaining chunk of work is to design better wlroots APIs to expose the
new renderer v6 capabilities. As part of this effort, I've been reviving the
work on the [scene-graph] API, which provides a higher-level API to compositors
and will allow wlroots to better take advantage of the hardware. I've ported
[Cage] to use the WIP scene-graph API, and the results are convincing! I'd like
to try to plug damage tracking support as well, to see how the design holds up
when adding new features.

In other Wayland news, we've finally finalized the
[DRM lease Wayland protocol][wp-drm-lease] (used for VR headsets), thanks to
the hard work of Xaver Hugl and Simon Zeni. The wlroots and Xwayland patches
are ready from my point-of-view. The last remaining piece is the Monado patch,
but we're close to the finish line!

I've continued working on [gamescope] for Valve. This gaming-focused Wayland
compositor can now handle TTY switching properly, has basic output hotplug
support and exposes a PipeWire stream for screen casting.

I've worked on smaller improvements on various other projects. ericonr has
added an [IPC to kanshi][kanshi-reload], allowing to reload the configuration
file on the fly (and in the future to programmatically switch the current
profile). I've submitted a new [extended-monitor] extension to IRCv3, to allow
clients to get reliable away notifications when privately discussing with
someone else. [I've][mesa-12370] [sent][mesa-12074] [and reviewed][mesa-12018]
[a bunch][mesa-12081] [of Mesa fixes][mesa-12362] for split render/display
SoCs such as the one found on the PinePhone. This should allow wlroots to work
better on these devices. columbarius has been pushing forward proper DMA-BUF
support in PipeWire.

The new project of the month is [blackbox]. It's a small utility which silently
records debug logs of a program, and dumps the recorded logs on-demand. It's
useful when trying to obtain information about a bug which can't be easily
reproduced.

That's all for now, see you soon!

[wlr-vk]: https://github.com/swaywm/wlroots/pull/2771
[wlr-screen-capture]: https://github.com/swaywm/wlroots/pull/2615
[wlr-output-layers]: https://github.com/swaywm/wlroots/pull/1985
[libliftoff]: https://github.com/emersion/libliftoff
[scene-graph]: https://github.com/swaywm/wlroots/pull/1966
[Cage]: https://github.com/Hjdskes/cage/pull/197
[wp-drm-lease]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/67
[gamescope]: https://github.com/Plagman/gamescope
[kanshi-reload]: https://github.com/emersion/kanshi/pull/107
[extended-monitor]: https://github.com/ircv3/ircv3-specifications/pull/466
[mesa-12370]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12370
[mesa-12074]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12074
[mesa-12018]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12018
[mesa-12081]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12081
[mesa-12362]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/12362
[blackbox]: https://git.sr.ht/~emersion/blackbox
