+++
date = "2021-01-18T00:00:00+02:00"
title = "Status update, January 2021"
slug = "status-update-25"
lang = "en"
tags = ["status update"]
+++

Hi all!

This month again, my main focus has been wlroots. I've focused on the internal
renderer refactoring (the so-called "[renderer v6]"). A lot of the work has
now been completed, and all backends now use the new interfaces under-the-hood.
With the help of Simon Zeni, we've gotten rid of the remaining OpenGL-specific
stuff from the backends. This means it's now possible to start working on
non-GL renderers! I've started to put together a [Vulkan allocator], and Simon
Zeni plans to work on a Pixman software renderer.

The work-in-progress Vulkan allocator uses
[`VK_EXT_physical_device_drm`][VK_EXT_physical_device_drm], a Vulkan extension
I've been working on to allow Wayland compositors to use Vulkan for rendering.
I've implemented it for [radv][radv VK_EXT_physical_device_drm] (Mesa's Vulkan
driver for AMD GPUs) and James Jones has been helping with a test suite patch.

While doing this, I've realized it causes some regressions on Nouveau, the
open-source driver for NVIDIA GPUs. I've tracked down [a bunch of bugs][nouveau
bugs], and submitted a [patch][nouveau linear scan-out patch] for one of them.
The Nouveau folks have been very helpful, special thanks to Ilia Mirkin! They
even went through the trouble of setting up Sway locally to reproduce and fix
one of the Mesa bugs, and then sent a [wlroots patch][wlroots x11 cursor patch]
for a bug they've hit on the way. Note, I still have some multi-GPU-related
Nouveau regressions to figure out, so not everything's been ironed out yet.

Ilia Bozhinov has contributed [xdg-foreign][wlroots xdg-foreign] support to
wlroots, so applications running in Flatpak should behave better when a dialog
(like a file selection dialog) is opened. He also helped reviewing some of the
DRM backend pull requests.

In other DRM-related news, I've continued sending some DRM documentation
patches and I've improved [drmdb]. The main drmdb change is a performance
improvement that I've been ignoring so far by hiding with a Varnish caching
proxy (yes, it's embarassing). drmdb deals with deeply-nested JSON documents:
each "snapshot" is stored as a JSON file. Operations on that type of database
are costly: I needed to open each file, parse the JSON blob, then decide what
to do with it. Many pages show information coming from a lot of devices, thus
took seconds to load.

For now, I've implemented a cache to keep the last few hundred used snapshots
in memory instead of loading each of them from disk. This has greatly helped
and I've been able to remove Varnish. I wonder if at some point I'll need to
improve this further. If anyone knows about a lightweight simple database for
deeply nested objects that ideally can be embedded in a Go executable, I'm all
ears.

I've also added some new features: the index page shows some stats, the
snapshot page now contains links for properties & objects, and buttons to
toggle some tree nodes ([example][drmdb snapshot example]). Maybe I'll add some
kind of syntax highlighting as well to make it more readable, ideas welcome!

Some of my other projects received some smaller updates too. minus added
[config reloading][tlstunnel config reload] support to tlstunnel, [soju] now
has an in-memory history buffer when the on-disk logs aren't enabled, and
[gamja] will automatically when the connection to the IRC server is lost.
Aditionally, I've started the release process for
[Wayland 1.19][wayland 1.18.91], and I've released [libdrm 2.4.104].

That's all, see you next month!

[renderer v6]: https://github.com/swaywm/wlroots/issues/1352
[Vulkan allocator]: https://github.com/swaywm/wlroots/pull/2648
[VK_EXT_physical_device_drm]: https://github.com/KhronosGroup/Vulkan-Docs/pull/1356
[radv VK_EXT_physical_device_drm]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/8390
[nouveau bugs]: https://github.com/swaywm/wlroots/issues/2526#issuecomment-760445781
[nouveau linear scan-out patch]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/8500
[wlroots x11 cursor patch]: https://github.com/swaywm/wlroots/pull/2660
[wlroots xdg-foreign]: https://github.com/swaywm/wlroots/pull/2487
[drmdb]: https://drmdb.emersion.fr/
[drmdb snapshot example]: https://drmdb.emersion.fr/snapshots/49ba37e0032f
[tlstunnel config reload]: https://lists.sr.ht/~emersion/public-inbox/patches/16082
[soju]: https://soju.im/
[gamja]: https://sr.ht/~emersion/gamja/
[wayland 1.18.91]: https://lists.freedesktop.org/archives/wayland-devel/2020-December/041668.html
[libdrm 2.4.104]: https://lists.freedesktop.org/archives/dri-devel/2021-January/293654.html
