+++
date = "2019-01-07T00:00:00+02:00"
title = "Status update, December 2018"
slug = "status-update-7"
lang = "en"
tags = ["status update"]
+++

The end of December has been pretty busy with not-open-source-stuff, so this
status update comes a little bit late and will be shorter than usual. Sorry
about that! Let's dig in.

Sway and wlroots now support the new [data-control-unstable-v1
protocol][wlroots-data-control]. This paves the way for clipboard managers and
`xclip` replacements. A notable tool that already supports it is [wl-clipboard].
Thanks Sergey Bugaev for helping us finishing this protocol!

A new project I've just started is [xdg-desktop-portal-wlr]. It's similar to
xdg-desktop-portal-gtk and xdg-desktop-portal-kde: it's a backend for the
xdg-desktop-portal D-Bus interface that allows Flatpak and regular clients to
perform screenshooting and screencasting (among other things). This is a missing
piece to allow for a screen capture mechanism that works on all desktops (yeah,
GNOME looooves D-Bus). Right now it's pretty basic and only supports
screenshooting via `grim`. Next up is screencasting.

I've spent quite some time [experimenting with DRM][drm-playground] (the Linux
API responsible for managing GPU resources). First, I've
[played with planes][drm-playground-planes], which makes the
hardware perform composition (take two images and blend them together). This
could be used to improve battery consumption in wlroots by putting some clients
on a plane and be able to skip rendering completely. I've tested this on my
ThinkPad (whose iGPU only has 3 planes) but also on a Raspberry Pi 3 which has
a lot more planes (10 of them).

![Screen with 10 planes connected to a RPi 3](https://sr.ht/oDDI.jpg)

The second thing [I've tried][drm-playground-writeback] is the new writeback
connector feature. Writeback connectors allows to read back the image displayed
on screen. This is useful for improving performance while screencasting and for
automated testing. While most drivers don't support writeback connectors yet,
VC4 does and the Raspberry Pi 3 exposes one, so that was pretty handy to try out
everything.

I'd like to keep experimenting with output cloning next, which allows to have
more screens connected and save resources if some of them share the same image.
In the end, playing with DRM has allowed me to better understand how it works,
and since I've only used the latest features (atomic modesetting, universal
planes) it'll probably help designing and reviewing the next DRM backend for
wlroots.

While doing this DRM work, I've extensively used ascent12's [drm_info] tool.
It's pretty useful to have a look at the whole DRM state while debugging.
I've contributed a few patches, mostly to support more features: DRM modes,
writeback connectors, aspect ratio, stereo 3D and so on.

Last topic: [mrsh] got some patches from contributors. Ben Brown has implemented
the `umask` builtin and added a `getopt` implementation. Drew DeVault has added
support for the `case` clause. Some have tried to build it on macOS, but there's
still a [linking issue][mrsh-macos] left (patches welcome!). I've slowly
continued to work on [job control][mrsh-job-control], I'll bump this task on my
TODO-list a little.

That's all for December! I said this post would be short, I guess I lied and
picked a few things that happened this week to compensate, so January's post
will be short instead. ;)

[wlroots-data-control]: https://github.com/swaywm/wlroots/pull/1423
[wl-clipboard]: https://github.com/bugaevc/wl-clipboard
[xdg-desktop-portal-wlr]: https://github.com/emersion/xdg-desktop-portal-wlr
[drm-playground]: https://github.com/emersion/drm-playground
[drm-playground-planes]: https://github.com/emersion/drm-playground/blob/78001c5a678972727d5710b6c9cfe5016d86c5ef/planes.c
[drm-playground-writeback]: https://github.com/emersion/drm-playground/blob/63e1b32435b81583f8b6e7961d23ffc70fd26d30/writeback.c
[drm_info]: https://github.com/ascent12/drm_info
[mrsh]: https://mrsh.sh/
[mrsh-macos]: https://github.com/emersion/mrsh/issues/78
[mrsh-job-control]: https://github.com/emersion/mrsh/tree/job-control
