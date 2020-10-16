+++
date = "2020-10-16T00:00:00+02:00"
title = "Status update, October 2020"
slug = "status-update-22"
lang = "en"
tags = ["status update"]
+++

Hi all, it's been a while! I've been taking some time off this month: I've been
hiking in Corsica (an island in the south of France) for 2 weeks! The path
(called [GR20]) was very difficult but the gorgeous landscapes made it entirely
worth it. :)

![Photo of a ridge in Corsica](https://pixelfed.social/storage/m/_v2/1521/1fb716abf-c07fca/FqvF9A5zS1qh/zSyjqk2TJ5TZzUu6BaJJYTg7zvW0f0U6nmtka2Oe.jpeg)

I've uploaded some pictures [on my Pixelfed account][pixelfed] if you're
interested (sorry about the picture quality, it seems Pixelfed compresses my
uploads).

Right before flying to Corsica, the [XDC2020 conference][xdc2020] was held
online. I've spent quite some time preparing it with James Jones from NVIDIA.
Together, we've come up with [a new proposal][xdc2020-constraints-talk] for
buffer constraints. James Jones has been working on the problem of allocating
buffers with the correct parameters to get optimal performance for a long time,
working with him has been very productive!

<iframe src="https://www.youtube-nocookie.com/embed/b2mnbyRgXkY?start=20290" allowfullscreen></iframe>

Following the presentation, we discussed with other developers during [a
workshop][xdc2020-constraints-workshop] to see if everything made sense to them
and what the next steps would be. In general the proposal was well-received,
and we've identified areas that need some work (the biggest topic is memory
heaps I guess). Here's the [workshop summary][xdc2020-constraints-summary]:

<iframe src="https://www.youtube-nocookie.com/embed/C3gltQa-SiM?start=17435" allowfullscreen></iframe>

I hope all of this work will help coming up with a solution that allows
potential performance as good as EGLStreams without all of its shortcomings.

At XDC2020 I've also given a [lightning talk][xdc2020-wlroots] about wlroots'
future steps in terms of rendering API (the so-called renderer v6 effort). The
presentation is pretty short and high-level, but you'll also find some links at
the end if you want to know more.

<iframe src="https://www.youtube-nocookie.com/embed/C3gltQa-SiM?start=17975" allowfullscreen></iframe>

There were a lot of other interesting presentations as well: [a gamescope
introduction][xdc2020-gamescope] by Plagman, ACO (the new AMD compiler
back-end), the upcoming Vulkan presentation timing extension, DRM modifiers for
AMD, and more!

While I'm talking about conferences, let me take this opportunity to
shamelessly advertise that I'll give a [talk about KMS][foss-north-talk] at
FOSS-north on November the 1st. KMS lacks docs, so hopefully this can help a
little.

Apart from XDC, I've been continuing my quest for a better solution for
automatic TLS. In the previous episode, I was working on [tlsd]. Since then
I've got ACME to work with tlsd, but took some time to take a step back and
look at the overall picture. Instead of having to patch each and every network
service to support tlsd, what if we moved all of the TLS handling inside a
single reverse proxy, and configure all network services to accept plain-text
connections from the reverse proxy?

This solution is much simpler than tlsd, and [tlstunnel] is born. tlstunnel is
a deamon that listens for incoming TLS connections, forwards them as plain-text
connections to backends, and maintains TLS certificates via ACME (and its
tls-alpn-01 challenge). The backends might still want to know about TLS
connection details, thankfully a solution called the [PROXY protocol] already
exists.

One pain point is that tlstunnel can't obtain wildcard certificates. Let's
Encrypt requires ACME clients to support the dns-01 challenge for this purpose,
which involves updating some DNS records. This is usually solved by adding
support for each and every DNS provider API in the ACME client. This is a no-go
for tlstunnel. I've [started a thread][acme-dns-01-limitations] on the ACME
mailing list to discuss potential better solutions.

While working on tlstunnel, I contributed to other projects such as [certmagic]
(which transparently handles all of the ACME operations) and [go-proxyproto].

I've invested some effort into a new Vulkan extension,
[VK_EXT_physical_device_drm]. Currently Vulkan clients can iterate over the
list of GPUs available on the system (via `VkPhysicalDevice`) but can't match
them reliably with DRM device nodes. This is a requirement for Vulkan clients
which want to interact with low-level graphics APIs such as GBM, like Wayland
compositors.

I've been reviewing a lot of patches in various projects. wlroots has gained
support for [seatd], so no longer depends on logind (read: systemd) for
unprivileged access to input and graphics devices. neon64 is working on
[GPU hotplug support][wlroots-gpu-hotplug] for wlroots, which is pretty
exciting. Aleix Pol from KDE is working on a new [xdg-activation] protocol
which would (finally!) allow Wayland clients to securely transfer focus to
another client.

While working on my IRC projects, I realized it wasn't possible to run multiple
IRC servers on the same machine and expect the ident protocol to work properly.
I've created a simple server, [ident-proxy], which forwards the incoming
requests to multiple backends and returns the first successful reply (if any).

My smaller projects have received some love too: [slurp 1.3] was released with
a bunch of new features (special thanks to Thayne McCombs!), [kanshi] now
supports include directives, and [drmdb] now displays upstream docs for KMS
properties.

That's all for these last two months! See you!

[pixelfed]: https://pixelfed.social/emersion
[xdc2020]: https://xdc2020.x.org/
[xdc2020-constraints-talk]: https://xdc2020.x.org/event/9/contributions/615/
[xdc2020-gamescope]: https://xdc2020.x.org/event/9/contributions/869/
[xdc2020-constraints-workshop]: https://xdc2020.x.org/event/9/contributions/634/
[xdc2020-constraints-summary]: https://xdc2020.x.org/event/9/contributions/868/
[xdc2020-wlroots]: https://xdc2020.x.org/event/9/contributions/870/
[xdc2020-gamescope]: https://youtu.be/b2mnbyRgXkY?t=25695
[VK_EXT_physical_device_drm]: https://github.com/KhronosGroup/Vulkan-Docs/pull/1356
[tlsd]: https://git.sr.ht/~emersion/tlsd
[tlstunnel]: https://sr.ht/~emersion/tlstunnel
[PROXY protocol]: https://www.haproxy.org/download/2.3/doc/proxy-protocol.txt
[acme-dns-01-limitations]: https://mailarchive.ietf.org/arch/msg/acme/w8sqjRuWclcsMsCOQR9PfCGvczY/
[certmagic]: https://github.com/caddyserver/certmagic/
[ident-proxy]: https://git.sr.ht/~emersion/ident-proxy
[go-proxyproto]: https://github.com/pires/go-proxyproto
[foss-north-talk]: https://foss-north.se/2020ii/speakers-and-talks.html#sser
[seatd]: https://sr.ht/~kennylevinsen/seatd/
[xdg-activation]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/50
[slurp 1.3]: https://github.com/emersion/slurp/releases/tag/v1.3.0
[kanshi]: https://github.com/emersion/kanshi
[drmdb]: https://drmdb.emersion.fr/
[wlroots-gpu-hotplug]: https://github.com/swaywm/wlroots/pull/2423
[GR20]: https://www.openstreetmap.org/relation/101692
