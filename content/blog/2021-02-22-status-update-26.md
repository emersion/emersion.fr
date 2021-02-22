+++
date = "2021-02-22T00:00:00+02:00"
title = "Status update, February 2021"
slug = "status-update-26"
lang = "en"
tags = ["status update"]
+++

Hi!

Once again my focus has been Wayland-related projects this month. A steady
stream of improvements made it into wlroots: Xyene made the X11 clipboard code
a lot more robust, bl4ckbone has made good progress on the upcoming
Pixman-based software renderer, and incremental patches slowly align the
wlroots API with [renderer v6]. Kenny Levinsen has improved Sway's transaction
infrastructure, so interactive move and resize operations should feel smoother
and glitch-free.

I've worked on new Wayland protocols as well. I've added documentation to my
[linux-dmabuf hints] patch, including guidelines for client and compositor
implementations. I've submitted a [security-context] proposal (finally!), but
it'll probably take some effort to make everybody happy. I've worked on a
wlroots implementation of the [xdg-activation] protocol by Aleix Pol, used to
transfer focus from one client to another (e.g. when clicking on a link in an
IM client).

As part of my contract with Valve, I've continued improving [gamescope]. Bas
Nieuwenhuizen has added support for format modifiers when importing client
buffers, fixing scrambled textures with some GPUs and removing some
Mesa-specific hacks we were using. I've written a small program that uses
VA-API to decode a video and display it directly
[via Wayland][vaapi-decoder wayland] or [via KMS][vaapi-decoder kms] without
involving the 3D engine (it's actually not that complicated!).

In the process, I've sent some [Mesa patches][mesa libva composed layers] to
improve interactions between VA-API and Wayland/KMS, and [amdgpu patches] to
fix issues related to the cursor plane. After debugging some Nouveau failures
on wlroots, I also sent [a patch][nouveau cursor pitch] to gracefully error out
instead of ending up with a black screen.

This month [xdg-desktop-portal-wlr] 0.2.0 has been released.
xdg-desktop-portal-wlr provides interoperability with xdg-desktop-portal
applications for wlroots compositors. This is used for instance by web browsers
for screen sharing. The new release brings various fixes, support for [basu]
for systemd-less setups and a `--replace` flag to ease bug reporting and
debugging. columbarius has been working hard on adding support for config files
and selecting which output to share, hopefully this can be merged soon.

I've continued work on the [soju] IRC bouncer. delthas has a work-in-progress
patch to allow clients to synchronize read receipts, so reading a message on
one device also marks it as read on all other devices. taiite has a
work-in-progress patch to handle case-mapping properly, fixing some
long-standing issues leading to inconsistent state. I have a work-in-progress
patch to save delivery receipts to the database, so that chat history isn't
lost when restarting the bouncer. There are some non-trivial questions for
each of these patches, but we're not too far away from a solution. tl;dr lots
of activity behind the scenes!

To wrap things up, I've created a new project: [tentative]. It's a small tool
to try out arbitrary KMS configurations. It's handy to check whether a kernel
driver supports a feature, for instance scaling and rotating buffers. KMS
drivers often expose a feature but don't necessarily support it in all cases
because of hardware limitations.

That's all for now, see you next month!

[renderer v6]: https://github.com/swaywm/wlroots/issues/1352
[linux-dmabuf hints]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/8
[security-context]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/68
[xdg-activation]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/50
[gamescope]: https://github.com/Plagman/gamescope
[vaapi-decoder wayland]: https://git.sr.ht/~emersion/vaapi-decoder/tree/wayland
[vaapi-decoder kms]: https://git.sr.ht/~emersion/vaapi-decoder/tree/kms
[mesa libva composed layers]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/9015
[amdgpu patches]: https://patchwork.freedesktop.org/project/amd-xorg-ddx/patches/?submitter=17330&q=&archive=&delegate=&state=*
[nouveau cursor pitch]: https://patchwork.freedesktop.org/patch/419353/
[xdg-desktop-portal-wlr]: https://github.com/emersion/xdg-desktop-portal-wlr
[basu]: https://github.com/emersion/basu
[soju]: https://soju.im/
[tentative]: https://git.sr.ht/~emersion/tentative
