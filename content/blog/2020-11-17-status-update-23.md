+++
date = "2020-11-17T00:00:00+02:00"
title = "Status update, November 2020"
slug = "status-update-23"
lang = "en"
tags = ["status update"]
+++

Hi! It's getting chilly over here, so I'm spending more time [reading] by the
fireplace. Fortunately, the cold doesn't yet prevent my fingers from typing
lines of code, so let's see what's new this month!

First off, I've worked on a talk about the Kernel Mode-Setting (KMS) interface
for the [foss-north] conference. My goal was to explain what it is, what it's
useful for and how to use it to get an image displayed on screen. It's just an
introduction, but also contains external links and suggestions for next steps
if you want to go further.

<iframe class="video" sandbox="allow-same-origin allow-scripts allow-popups" src="https://conf.tube/videos/embed/c023f9e8-0bae-4aa1-ac91-bfc5f21c46aa" frameborder="0" allowfullscreen></iframe>

KMS documentation is sparse, and this is one of my efforts to improve it
alongside [drmdb], various kernel patches, and recently a [libdrm patch] as
well. I've received a lot of good feedback for this talk, so this is pretty
motivating to continue these efforts!

In Wayland news, Drew DeVault has [decided to hand over][wlroots-maintenance]
the maintenance of wlroots and Sway. In practice this shouldn't change a lot of
things, apart from the fact releases are now signed with my PGP key. Thanks for
trusting me!

I've released [wlroots 0.12], which mostly contains bug fixes and minor
improvements. But some exciting stuff is lined up for the next release: the
massive renderer v6 refactoring has finally started inside the DRM and headless
backends. My plan is to keep renderer v6 an internal detail for now to not
break our API, extend it to all backends (X11 and Wayland), move the common
bits outside of the backends into `wlr_output`, then expose the new interfaces
to allow compositors to take advantage of them.

I've also helped out a little the [GPU hotplug pull request][wlroots-gpu-hotplug]
by doing some [refactoring][wlroots-session-refactor] that should make it
easier to implement this new feature.

I've worked on Valve's [gamescope] as well. I've chased down a bug that
required completing the TitanFall 2 gauntlet in less than 1 minute, so had a
good excuse to play while working :P. I'm still working on making gamescope
take full advantage of KMS planes, and that also benefits the rest of the
ecosystem since I've written some [libliftoff] and [amdgpu] patches as well
(more are to come!).

I've also become a FreeDesktop.Org sysadmin this month. My main goal is to
improve our mailing list setup (by setting up ARC for instance), but I've also
been helping out in some domain name migrations.

I've started two new projects this month. The first one is [scfg]: it's a
simple configuration file format very similar to the ones used by Sway/i3,
Caddy, kanshi, tlstunnel and many more. I think it has its uses when you need
something more expressive than INI, but less complicated than YAML/TOML/HCL.
The format itself should sound familiar to many people. There are already 4
scfg implementations (C, Go, Python and Rust).

I've continued my work on [tlstunnel], and created a new project designed to
be used in tandem with it: [kimchi]. I really like some parts of Caddy, but
dislike Caddy v2 (scope too large and [a bunch of bad
decisions][caddy-v2-dumb]). I've quickly hacked together a minimal HTTP server
which supports the PROXY protocol so that it can integrate well with tlstunnel.
kimchi now almost fits my personal needs, I'll migrate to it once I've filled
the holes.

One last thing worth noting is the renewed activity on [basu]. The official
D-Bus library is a pain to use, so my tools use libsystemd's D-Bus library
instead, which makes it a little bit less painful to deal with D-Bus. However
libsystemd's D-Bus library isn't available on systems without systemd nor
elogind. basu exposes the same API as a stand-alone library. It now compiles
fine on Alpine Linux, and I hope we can get FreeBSD support as well at some
point. Thanks Kenny Levinsen and Hummer12007 for helping out!

That's all for this month! See you!

[reading]: https://l.sr.ht/ob9s.jpg
[foss-north]: https://foss-north.se/2020ii/speakers-and-talks.html#sser
[drmdb]: https://drmdb.emersion.fr/
[libdrm-man]: https://gitlab.freedesktop.org/mesa/drm/-/merge_requests/72
[wlroots-maintenance]: https://drewdevault.com/2020/10/23/Im-handing-wlroots-and-sway-to-Simon.html
[wlroots 0.12]: https://github.com/swaywm/wlroots/releases/tag/0.12.0
[wlroots-gpu-hotplug]: https://github.com/swaywm/wlroots/pull/2423
[wlroots-session-refactor]: https://github.com/swaywm/wlroots/pull/2465
[gamescope]: https://github.com/Plagman/gamescope
[libliftoff]: https://github.com/emersion/libliftoff
[amdgpu]: https://lists.freedesktop.org/archives/amd-gfx/2020-November/055986.html
[scfg]: https://git.sr.ht/~emersion/scfg
[tlstunnel]: https://sr.ht/~emersion/tlstunnel
[kimchi]: https://sr.ht/~emersion/kimchi/
[caddy-v2-dumb]: https://octodon.social/@emersion/104563230754934208
[basu]: https://github.com/emersion/basu
