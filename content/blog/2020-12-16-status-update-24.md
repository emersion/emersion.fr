+++
date = "2020-12-16T00:00:00+02:00"
title = "Status update, December 2020"
slug = "status-update-24"
lang = "en"
tags = ["status update"]
+++

Hi all! This status update is the 24th one, so it's been 2 years I've started
writing those now (ignoring a little hiatus). Time flies!

This month I've invested a lot of time into wlroots. My main focus has been
renderer v6, which has now been internally rolled out to all backends. I'm now
working on moving all of the rendering stuff out of the backends, starting with
the cursor handling. This should also help with the work-in-progress [explicit
synchronization] implementation. Apart from these big under-the-hood changes,
I've also improved the DRM backend, fixing some bugs and simplifying the logic.

As part of my [gamescope]-related work I've contributed to a few upstream
projects like amdgpu and radv. I've sent a dozen amdgpu patches to improve the
atomic commit checks. A bad KMS configuration would previously result in a
corrupted result, now amdgpu lets user-space know that the configuration is
invalid and user-space can fall back to something else. This greatly helps
[libliftoff] to choose the best possible configuration.

I've continued my work on improving docs for DRM in the kernel, and also sent a
few patches to check drivers provide a sensible set of primary planes. I'm now
also a libdrm committer and pushed a few documentation improvements there.

Apart from graphics, other of my projects have received some interesting
updates too. Thanks to delthas, the [soju] IRC bouncer can now be configured to
automatically detach a channel when there's no activity, and to automatically
re-attach when there's new activity. This can be used for instance to hide
low-traffic channels, or automatically detach from a high-traffic channel if
you're not highlighted for a while. I've also rolled out delivery receipts,
which allow to avoid loosing messages when a client connection breaks. Various
bug fixes have been contributed by Hubert Hirtz. Thanks both of you!

I've polished [go-msgauth], my Go library for DKIM and other related standards.
It's now used in production on the SourceHut mail servers. Our previous
OpenDKIM setup was causing DKIM validation failures because of some various
musl-related issues. go-msgauth should fix that.

Last by not least, the first version of the [basu] D-Bus library has been
released. Patches to add basu support to [mako] and swaybar have been merged.
The next big milestone will be FreeBSD support, Kenny Levinsen has gotten as
far as making a few tests pass (with some hacks). Soon™!

See you next month!

[explicit synchronization]: https://github.com/swaywm/wlroots/pull/2070
[gamescope]: https://github.com/Plagman/gamescope
[libliftoff]: https://github.com/emersion/libliftoff
[soju]: https://sr.ht/~emersion/soju/
[go-msgauth]: https://github.com/emersion/go-msgauth
[basu]: https://github.com/emersion/basu
[mako]: https://github.com/emersion/mako
