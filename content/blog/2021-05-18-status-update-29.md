+++
date = "2021-05-18T00:00:00+02:00"
title = "Status update, May 2021"
slug = "status-update-29"
lang = "en"
tags = ["status update"]
+++

Hi!

This month, a lot has happened in the Wayland world as usual. The most exciting
news is the introduction of the new [Pixman renderer] in wlroots, allowing more
Wayland compositors to be used on setups lacking a proper GPU or GPU driver.
The use-cases include old hardware, hardware where an open-source driver isn't
available, continuous integration, VMs, and more. The Pixman renderer should be
significantly faster than our previous llvmpipe-based fallback. That said,
there are still a lot of opportunities for optimizations (if you're interested,
have a look at the various TODOs in `render/pixman/renderer.c`).

In addition to the Pixman renderer, the [backend + renderer + allocator
initialization has been revamped][allocator autocreate] to better accommodate
for many types of backends and renderers (including third-party
implementations). The initialization is a little tricky because each of these
components is only compatible with a subset of the others. A [DRM dumb
buffer allocator] has been introduced to allow the Pixman renderer to work with
the DRM backend, and the GLES2 renderer has been made optional. The GLES2
renderer is now able to [re-use DMA-BUF textures], improving performance on
multi-GPU setups among other things. Much of this wlroots work has been done by
bl4ckb0ne, thanks a lot!

In other Wayland news, I've started working on a new protocol:
[linux-explicit-synchronization-v2]. The first version relies on the kernel's
`sync_file` mechanism, but a new abstraction has been introduced since then:
`drm_syncobj` timelines. The timelines remove many limitations from the
previous API and are easier to use, see the
[Vulkan blog post][Vulkan timeline semaphores]. The goal of the new Wayland
protocol is to allow compositors which haven't implemented v1 yet to
fast-forward to the new API without having to care too much about the legacy
API. The triggers for all of this work are the repeated [calls to action][Jason explicit sync]
by Jason Ekstrand, and the recent (and lengthy) [thread about upcoming AMD hardware][AMD explicit sync]
on dri-devel. I've also submitted [another core protocol patch][wl_surface.get_release]
to allow clients to better track buffer releases, a service that was provided
by linux-explicit-synchronization-v1.

I've continued contributing to Mesa: as part of my Valve-sponsored work, all of
my [libva patches][mesa VASurfaceAttribDRMFormatModifiers] have been merged and
radv can now [import tiled multi-planar buffers][radv tiled multi-planar].
Additionally, I've started working on [a new EGL extension][EGL_HOST_POINTER_MESA]
to allow rendering to main memory. This would allow the GLES2 renderer in
wlroots 0.13+ to be used with llvmpipe, something that has been lost during the
renderer v6 upgrade. The main motivation is to allow compositors that
hard-depend on OpenGL (e.g. Wayfire) to work on setups without a GPU.

This month marks the very first release of my [soju] IRC bouncer. Thanks a lot
to all contributors, especially delthas and Hubert Hirtz for their significant
involvement! I've been using soju for a while, and I hope we'll be able to offer
an upgrade for the traditional IRC experience (while remaining in line with the
spirit of IRC). There are many in-progress workstreams, including [offering a
better API to register an account][account-registration] and [improving chat
history fetching][CHATHISTORY TARGETS].

Speaking of releases, I've also tagged the long overdue [mako 1.5]. The
notification daemon has gained a whole lot of new features: more customization
options, an history buffer, regex matching, better support for non-systemd
distributions, among other things. In the master branch, [support for
synchronous hints][mako synchronous hints] has been merged, making it easier to
replace previous notifications from scripts.

That's about it for this month! As a spoiler for the next status update, I've
started [go-emailthreads], a new project to replace [python-emailthreads]. This
should help lists.sr.ht get better at presenting email discussions and allow
a full migration to GraphQL. Stay tuned for more!

[Pixman renderer]: https://github.com/swaywm/wlroots/pull/2661
[DRM dumb buffer allocator]: https://github.com/swaywm/wlroots/pull/2700
[allocator autocreate]: https://github.com/swaywm/wlroots/pull/2884
[re-use DMA-BUF textures]: https://github.com/swaywm/wlroots/pull/2851
[CHATHISTORY TARGETS]: https://github.com/ircv3/ircv3-specifications/pull/450
[account-registration]: https://github.com/ircv3/ircv3-specifications/pull/435
[EGL_HOST_POINTER_MESA]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10744
[mesa VASurfaceAttribDRMFormatModifiers]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10237
[radv tiled multi-planar]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/10623
[mako 1.5]: https://github.com/emersion/mako/releases/tag/v1.5
[mako synchronous hints]: https://github.com/emersion/mako/commit/4a30dfb4361e9e6603548a891f4f353dde3563eb
[go-emailthreads]: https://git.sr.ht/~emersion/go-emailthreads
[python-emailthreads]: https://github.com/emersion/python-emailthreads/
[linux-explicit-synchronization-v2]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/90
[Vulkan timeline semaphores]: https://www.khronos.org/blog/vulkan-timeline-semaphores
[wl_surface.get_release]: https://gitlab.freedesktop.org/wayland/wayland/-/merge_requests/137
[Jason explicit sync]: https://lwn.net/ml/dri-devel/CAOFGe94jy2VYDPbkMW8ZuNdAeM+HS8sM1OAYFGd9JKc1V7PVOQ@mail.gmail.com/
[AMD explicit sync]: https://lists.freedesktop.org/archives/dri-devel/2021-April/303671.html
[soju]: https://soju.im/
