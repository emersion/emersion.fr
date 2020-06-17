+++
date = "2020-06-17T00:00:00+02:00"
title = "Status update, June 2020"
slug = "status-update-19"
lang = "en"
tags = ["status update"]
+++

Time for a new monthly status update! Let's start with Wayland stuff. Once
again I've continued working on wlroots' DRM backend. I've submitted a bunch of
bugfixes for all of the atomic refactoring done last month. I've also [started
working][swapchain] on integrating our long-planned [renderer v6] interfaces
into the DRM backend.

"Renderer v6" is a proposal to change how the rendering interfaces work in
wlroots. Right now the backends (DRM, Wayland, X11, headless) have a hard
dependency on EGL. Additionally, the renderer depends on the backend; it's
initialized and used differently on each backend. Renderer v6's goal is to
completely split the backends and the renderer. This is achieved by introducing
a buffer interface: the renderer writes to a buffer, which the compositor can
then hand over to the backend for display.

There are a number of upsides to this design. Renderer v6 will enable non-EGL
renderers like Vulkan, will give more control over the swapchain, and will
result in a simpler design than trying to workaround `EGLSurface`/`VkSurface`/
`gbm_surface`/etc to achieve the same goals.

Up until now renderer v6 work has been mostly preparatory work, tweaking some
interfaces to better fit the future APIs like `wlr_buffer`, and adding some
helpers like `wlr_dmabuf_attributes` and `wlr_drm_format_set`. This month, I've
been adding the remaining pieces of the puzzle in my work-in-progress pull
request: `wlr_allocator` and `wlr_swapchain`.

A huge part of the renderer v6 effort has been to figure out how to
incrementally refactor wlroots. Big patches with multiple thousands lines of
code changed are making the reviewers' work extremely long and difficult. They
are a lot of effort, thus take a long time and need to be rebased constantly.
They make it impossible to bisect the Git history to understand bugs. That's
why my pull request only touches the DRM backend internals: it allows wlroots
to us the new toys for a single backend without actually breaking any API.
Once we're confident this design works as expected, we can make other backends
migrate to the new APIs internally, one by one, and then move everything out of
the backends into `wlr_output` itself (still without breaking the compositor
API).

Of course there are still some open questions regarding renderer v6: it's not
yet clear how it'll blend with `wlr_matrix` helpers which expect Y-inverted
output, software rendering which doesn't work with DMA-BUFs, hardware planes
and the future scene-graph API. The path forward is slowly becoming clearer and
clearer, I'm excited to see wlroots continue to pioneer the Wayland landscape.

Apart from renderer v6, there have been some other very interesting additions
to wlroots: any1 has added [DMA-BUF support to the screencopy
protocol][screencopy dmabuf], allowing more efficient screen capture for
clients that need to perform a GPU copy. I've finished my [viewporter] protocol
implementation, allowing older X11 games to work better and future
optimizations in video players and web browsers (I've heard Firefox plans to
use it with their GPU-accelerated rendering engine).

Xyene and Kenny Levinsen have send a bunch of bug fixes for Sway, greatly
improving the user experience around input handling and moving/resizing
windows. Thanks!

Looking at the wider Wayland ecosystem, the [linux-dmabuf hints] protocol has
been improved after reviews from Daniel Stone and Scott Anderson. I hope we'll
be able to finally come to a consensus soon and finally be able to ditch the
old `wl_drm` protocol and benefit from the performance improvements of
per-surface hints. I've also sent some [xorg-xserver][xserver linux-dmabuf] and
[Mesa][vulkan wsi linux-dmabuf] patches to use newer interfaces when available,
allowing direct scan-out in more situations.

[I've][libdrm docs] [also][kms crtc props docs] [been][kms link-status docs]
[submitting][drm modifiers docs] [patches][gbm map docs] to improve the Linux
graphics docs. When I first tried to understand how all of it worked I had a
hard time because there are almost no docs. The situation has improved a little
nowadays with e.g. [kms-quads], but there's still a lot to be done. I've become
a drm-misc committer to continue this work, so feel free to CC me if you submit
a patch about DRM docs!

The [soju] IRC bouncer keeps improving and is now definitely production-ready
for small instances. delthas has added support for the [CHATHISTORY] extension,
allowing clients to query history and implement features like infinite
scrollback. delthas has also added a [`user create`][user create] command to create users
on-the-fly. [SASL EXTERNAL] has been implemented by foxcpp to enable
authentication via TLS client certificates (also known as "CertFP"). Last, I've
added a [`network update`][network update] command to edit a network's settings and added support
for [WebSockets][websockets] (for Web-based IRC clients).

Let's wrap this status update up by mentioning my linker [sld]. I've added
support for `.rodata` sections (reserved for read-only data), and I have a
work-in-progress patch for `.bss` sections (reserved for zero-initialized
data). It's not yet quite working and it's a little bit difficult to debug
(because it's segfaulting before the executable is actually started), but
hopefully I'll find some time to debug it and get it working.

See you next month!

[viewporter]: https://github.com/swaywm/wlroots/pull/2092
[screencopy dmabuf]: https://github.com/swaywm/wlroots/pull/2133
[swapchain]: https://github.com/swaywm/wlroots/pull/2240
[xserver linux-dmabuf]: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/450
[libdrm docs]: https://gitlab.freedesktop.org/mesa/drm/-/merge_requests/72
[gbm get_fd_for_plane]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/5442
[vulkan wsi linux-dmabuf]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/4942
[kms crtc props docs]: https://patchwork.freedesktop.org/patch/366504/
[kms link-status docs]: https://patchwork.freedesktop.org/patch/368634/
[drm modifiers docs]: https://patchwork.freedesktop.org/patch/367488/
[gbm map docs]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/5238
[CHATHISTORY]: https://git.sr.ht/~emersion/soju/commit/f7894e612b13e851f0def074fc929ce5ad6121a8
[SASL EXTERNAL]: https://git.sr.ht/~emersion/soju/commit/203dc3df6ada6d9567382d3a40b39e3927188033
[network update]: https://git.sr.ht/~emersion/soju/commit/c709ebfc912cfca9b9c412bc27bd811d5115ba51
[user create]: https://git.sr.ht/~emersion/soju/commit/5be25711c7366a79d7bf361a9124e21ca4bd3f6a
[websockets]: https://git.sr.ht/~emersion/soju/commit/d0cf1d2882cf193db0825671b3e5f3a4db018f07
[renderer v6]: https://github.com/swaywm/wlroots/issues/1352
[linux-dmabuf hints]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/8
[kms-quads]: https://gitlab.freedesktop.org/daniels/kms-quads
[sld]: https://git.sr.ht/~emersion/sld
[soju]: https://soju.im/
