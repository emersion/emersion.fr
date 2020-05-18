+++
date = "2020-05-18T00:00:00+02:00"
title = "Status update, May 2020"
slug = "status-update-18"
lang = "en"
tags = ["status update"]
+++

This month I've started working with Valve, the company behind the Steam game
platform. I'll be helping them improving [gamescope], their gaming Wayland
compositor. Unlike existing compositors, gamescope uses Vulkan and [libliftoff].
Because these are pretty new technologies, there are a lot of missing pieces in
various projects. Working on gamescope involves sending patches to other
projects across the graphics stack to get everything working properly, this is
pretty cool. For instance, I've sent a [RADV patch][radv-dmabuf-import] to fix
Vulkan DMA-BUF import.

In other Wayland news, I've worked a lot on wlroots' DRM backend. DRM has two
interfaces: the legacy interface, which we need to continue to support for older
drivers, and the atomic interface, which has all the shiny new features. The
atomic interface allows to take better advantage of modern GPUs: libliftoff
needs the atomic interface to use hardware planes.

The legacy interface provides a lot of functions to update the GPU state (e.g.
`drmModeSetCrtc` to set the mode, `drmModeSetCursor` to set the cursor image,
`drmModeMoveCursor` to move it and so on). The atomic interface, on the other
hand, allows the compositor to submit the whole GPU state in one commit. Up
until now, we were using the atomic interface just like the legacy interface,
submitting a lot of small atomic commits, each one changing part of the state.
With the help of Scott Anderson I've incrementally reworked the DRM backend to
stop doing that and to submit a single atomic commit per page-flip instead.

The next step is to add support for test-only atomic commits, allowing
compositors to check whether a configuration will work before applying it. This
should help compositors avoid some black-screen-on-hotplug situations. This
also paves the way for libliftoff support in wlroots. On the long run, all of
this work will integrate with [output layers and the
scene-graph][wlroots-output-layers-scenegraph].

The [mako] notification daemon is getting some interesting improvements. Ongy
has been working on multiple surface support, which will allow users to specify
the notification position on a per-notification basis. Up until now, this wasn't
possible; all notifications were showing up next to each other. For example,
important notifications could show up over fullscreen apps, or
volume/brightness notifications could show up in the middle of the screen. This
will enable a whole new class of use-cases!

Additionally, the notification icon position can now be customized. I also have
a work-in-progress patch to allow commands to be executed when a new
notification appears.

I've also started working on a static linker, [sld]. My goal is to keep it
small and simple. Right now it can already link `exit(42)` and "Hello World"!
The next step is to link "Hello World" with musl, which is pretty close (mostly
blocked by `.bss` support). I still need to redesign the current code to allow
for dead code elimination, so I don't expect the current architecture to stay
as-is for long. Working on a linker has been pretty fun so far! (And omitting
dynamic linking sure avoids a lot of complexity and magic.)

Other projects have seen various improvements. Max Mazurov has contributed a
lot of patches for my Go libraries, adding client support to [go-milter] and
server OAUTHBEARER support to [go-sasl] among a lot of other things. [sidediff]
now supports patches in addition to diffs, so you can `curl` a lists.sr.ht
patch directly into it. [xdg-desktop-portal-wlr] 0.1.0 has been released and is
proving pretty stable, allowing Sway users to use their web browser's screen
sharing feature. The webmail project formely known as koushin has been renamed
to [alps]. Drew DeVault and myself have been pushing a lot of small features
and bug fixes.

And that's all for this month!

[sld]: https://git.sr.ht/~emersion/sld
[sidediff]: https://git.sr.ht/~emersion/sidediff
[gamescope]: https://github.com/Plagman/gamescope
[libliftoff]: https://github.com/emersion/libliftoff
[radv-dmabuf-import]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/4885
[xdg-desktop-portal-wlr]: https://github.com/emersion/xdg-desktop-portal-wlr
[wlroots-output-layers-scenegraph]: https://github.com/swaywm/wlroots/pull/2165
[alps]: https://sr.ht/~emersion/alps
[mako]: https://github.com/emersion/mako
[go-sasl]: https://github.com/emersion/go-sasl
[go-milter]: https://github.com/emersion/go-milter
