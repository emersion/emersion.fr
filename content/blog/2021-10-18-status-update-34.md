+++
date = "2021-10-18T00:00:00+02:00"
title = "Status update, October 2021"
slug = "status-update-34"
lang = "en"
tags = ["status update"]
+++

Hi! Another month, another status update. Let's dig in!

The highlight of this month is the launch of [chat.sr.ht], a hosted IRC bouncer
service based on [soju] and [gamja]. The service is in closed beta for now,
feel free to ping me if you want to try it out!

It took some effort to setup the new server and iron out the initial set of
issues (especially a deadlock I couldn't reproduce locally). Special thanks to
Hubert Hirtz who's added PostgreSQL support to soju, which should scale a lot
better than SQLite (SQLite is still great for small instances).

gamja has been extended to support a whole bunch of IRCv3 extensions
(`extended-join` + `account-notify` + WHOX) and should now reliably display
account names next to nicknames for authenticated users (note, soju itself is
still missing WHOX at the moment). gamja now re-joins channels on reconnect,
which is handy when running it without a bouncer.

wlroots has been pretty quiet. Thanks to nyorain and feedback from Vulkan
experts, we've finally merged the [Vulkan renderer], enabling a bunch of
potential future optimizations and making it easier to write Vulkan-based
Wayland compositors. I've slowly continued my work on dmabuf hints, now renamed
to [dmabuf feedback].

I've started a new project to help with the future migration of the Sway and
wlroots projects off of GitHub. [dalligi] allows to plug builds.sr.ht to a
GitLab instance. Since it appears as a runner from GitLab's point of view, it
integrates properly with things like merge request checks. On a different note,
I've migrated [swaywm.org] to SourceHut Pages (it was previously hosted on
GitHub pages).

I've worked on a number of kernel improvements. I've fixed corrupted fullscreen
buffers on older AMD cards by adding a [tiling check] to amdgpu. After a lot of
back-and-forth, it appears we found a consensus to [re-enable the overlay plane]
on amdgpu, allowing [libliftoff] to better take advantage of the hardware. Some
other patches are still in review. [One patch][tearfree] eases seamless
"tear-free" transitions between DRM clients (boot screen, display manager, and
compositors). [Another series][connector-uevent] adds more metadata to connector
hotplug events sent by the kernel, and allows compositors to avoid force-probing
all connectors each time (this can take quite some time).

That's all for now, see you next month!

[chat.sr.ht]: https://man.sr.ht/chat.sr.ht/
[soju]: https://soju.im
[gamja]: https://sr.ht/gamja
[Vulkan renderer]: https://github.com/swaywm/wlroots/pull/2771
[dmabuf feedback]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/8
[tiling check]: https://patchwork.freedesktop.org/patch/455904/
[re-enable the overlay plane]: https://patchwork.freedesktop.org/patch/459229/
[libliftoff]: https://github.com/emersion/libliftoff
[tearfree]: https://patchwork.freedesktop.org/series/95561/
[connector-uevent]: https://patchwork.freedesktop.org/series/95938/
[dalligi]: https://git.sr.ht/~emersion/dalligi
[swaywm.org]: https://swaywm.org
