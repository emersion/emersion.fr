+++
date = "2021-04-15T00:00:00+02:00"
title = "Status update, April 2021"
slug = "status-update-28"
lang = "en"
tags = ["status update"]
+++

Hi all!

Let's start this status update with the biggest news this month: [Sway 1.6] and
[wlroots 0.13.0] have been released! Alongside the user-visible improvements
mentioned in the release notes and the numerous bug fixes, we've put a lot of
effort into under-the-hood changes as well, mostly inside wlroots. wlroots
0.13.0 is the first release to contain the initial set of renderer v6 patches.
We have a few regressions (for very old hardware, and for multi-GPU nouveau
setups) mainly due to our unusual new internal architecture, but overall I'm
pretty happy with the outcome.

![sway tree in winter](https://l.sr.ht/0JbA.jpg)

<center><small>Winter Sway tree, courtesy of roipoussiere</small></center>

I've continued renderer v6 efforts this month too. The DRM backend can now make
use of atomic test-only commits to check whether a buffer can be directly
displayed without any copy on an output. I'm in the process of re-working our
buffer management logic to make it less OpenGL-specific and avoid needless
DMA-BUF import operations.

In parallel, bl4ckb0ne and nyorain have continued working on a
[Pixman][Pixman renderer] and a [Vulkan renderer], respectively. The Pixman
renderer is almost complete and getting quite close to being mergeable. It has
required to adapt quite a few wlroots interfaces which were definitely not
designed for software renderers, but all of that work is now done and merged.
The Vulkan renderer works and just needs reviews, I'll start reading the
patches in detail in the next days. As expected, it's quite verbose.

As the last wlroots news, we've [removed][wlroots mandatory libseat] all of our
session management code, and we now entirely rely on [libseat]. This is
exciting news because the session code is tricky to get right, we now have a
single code-path, we better support our non-systemd users, and we can share all
of this goodness with other Wayland compositors! Weston is next on the line,
[initial support][Weston initial libseat] for libseat has been merged a few
days ago, and the plan is to [make libseat mandatory][Weston mandatory libseat]
there too.

In other graphics-related news, the Valve-sponsored [gamescope] compositor now
better supports format modifiers, removing the need for some fragile
driver-specific workarounds in the Vulkan code. I've also worked on improving
support for AMD's hardware-accelerated video decoding path to directly display
buffers on screen without any intermediate copy. This has led me to [improve
VA-API's support for format modifiers][libva modifiers] (although some more
work is still required in this area). I've also submitted
[Mesa][Mesa AMD tiled multi-planar] and [amdgpu][amdgpu tiled multi-planar]
patches to support _tiled multi-planar buffers_. If that sounds alien to you,
it just means hardware-accelerated video decoding can be used in more
situations.

A lot of interesting patches have been pushed to my IRC bouncer project [soju].
Among other things, soju now [correctly handles IRC
case-mapping][soju case-mapping] thanks to taiite. This is necessary to avoid
bugs and confusion when a user types `/query simon` but the recipient is
actually named "Simon". Additionally, soju now [no longer looses the
backlog][soju save delivery receipts] on restart, so upgrades can be performed
without disturbing users too much. I think we're getting quite close to an
initial release!

As a maintainer of the builds.sr.ht FreeBSD image, I've [added a new FreeBSD
13.0 image][builds.sr.ht freebsd 13.x] following the recent upstream release.
If your build manifests are using `freebsd/latest`, they've been automatically
upgraded. Enjoy!

As always, there's a ton of background work I've been doing as well. I've
reviewed a lot of patches across many projects (wayland-protocols, libdrm,
Mesa, various Go libraries, of course wlroots/Sway, and many more). I've been
doing more paperwork-y tasks as well, such as removing legacy chunks out of the
Wayland website or helping out with some X.Org domain name migrations. This
kind of work takes time and is not so exciting to mention in a status update,
but it's necessary to keep the projects going.

That's all for this month! Thanks a lot for your support, see you!

[Sway 1.6]: https://github.com/swaywm/sway/releases/tag/1.6
[wlroots 0.13.0]: https://github.com/swaywm/wlroots/releases/tag/0.13.0
[Pixman renderer]: https://github.com/swaywm/wlroots/pull/2661
[Vulkan renderer]: https://github.com/swaywm/wlroots/pull/2771
[libseat]: https://git.sr.ht/~kennylevinsen/seatd/
[wlroots mandatory libseat]: https://github.com/swaywm/wlroots/pull/2839
[Weston initial libseat]: https://gitlab.freedesktop.org/wayland/weston/-/merge_requests/589
[Weston mandatory libseat]: https://gitlab.freedesktop.org/wayland/weston/-/issues/488
[gamescope]: https://github.com/Plagman/gamescope
[libva modifiers]: https://github.com/intel/libva/pull/505
[Mesa AMD tiled multi-planar]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10134
[amdgpu tiled multi-planar]: https://patchwork.freedesktop.org/patch/426208/
[soju]: https://soju.im/
[soju case-mapping]: https://git.sr.ht/~emersion/soju/commit/bdd0c7bc06ece87b796c5ad0d5b248d4c14fd4ef
[soju save delivery receipts]: https://git.sr.ht/~emersion/soju/commit/1e4ff49472467e1e30c897608aeddb6921dc81c7
[builds.sr.ht freebsd 13.x]: https://git.sr.ht/~sircmpwn/builds.sr.ht/commit/e11f1cff901371b118110a64703cd8a6cd6286c4
