+++
date = "2019-12-16T00:00:00+02:00"
title = "Status update, December 2019"
slug = "status-update-13"
lang = "en"
tags = ["status update"]
+++

I've stopped writing status updates for a while, because I had too little time
while working at Intel. Now that [I've joined SourceHut][joined-sourcehut] and
I'm working full-time on open-source software, I have much more things to talk
about when it comes to monthly contributions!

## wxrc

I've spent my first month at SourceHut working on virtual reality. Together
with Drew, we added GLES support to Monado and built [wxrc], a wlroots-based
compositor for VR.

![htop terminal window blended in a 3D scene](https://sr.ht/L04N.png)

We've got pretty far: you can use wxrc to spawn windows in a 3D space,
interact with them, manipulate them, [change the
scenery](https://sr.ht/9DQE.png) and [spawn 3D objects](https://sr.ht/CO8m.png).
The result is pretty cool!

## New project: koushin

This month I've started building a new webmail called [koushin]. The goal is to
write a simple, secure and fast webmail:

- Easy to deploy: written in Go, almost zero-configuration, single binary
- Extensible & customizable: themes allows to change how koushin looks, plugins
  allows to change how it behaves
- JavaScript is optional (for the default themes and plugins)

Plugins are designed to be pretty powerful, they can add additional
functionality to existing pages and add new ones.  They can be written in Go or
in Lua, each language having its own upsides.  Things like contacts, calendar,
e-mail filters can be implemented via plugins.  In fact, all of the current
pages are already bundled in a plugin and don't live in the core.

Drew contributed a SourceHut theme, see the cool screenshots below. Of course
the project is very young so everything is still pretty barebones, but it
should be easy to build upon the current architecture. Thanks [Migadu][migadu]
for sponsoring this work!

![The mailbox view](https://sr.ht/saZf.png)

![The mesage view](https://sr.ht/ex9d.png)

![Replying to a message](https://sr.ht/6Nvf.png)

## libliftoff & glider

I've made good progress on the [libliftoff] front as well. I've focused on
[glider], an experimental libliftoff-based Wayland compositor. I want to prove
that libliftoff's design works and incubate future wlroots APIs.

I've got to the point where glider can render a surface, either by compositing
it or by displaying it in a hardware plane if supported. I've made some [early
power consumption benchmarks][glider-early-bench] and it seems like libliftoff
does help improving battery life!

The next steps include adding support for multiple outputs to glider,
performing more benchmarks (e.g. while playing a video or browsing the web)
and make libliftoff smarter.

My [FOSDEM libliftoff talk] has been accepted, so if you're interested in an
introduction to KMS planes and a detailed status update, make sure to come
watch it!

## mrsh

Regarding [mrsh], I've mostly fixed bugs this month. Almost all of the hard
problems have been fleshed out and I think we're not too far from a first
unstable release. Thanks to everyone who reported their issues and sent
patches! I'll continue to focus on fixing more bugs and testing more shell
scripts.

* * *

I've done a lot of other things as well. The new [wayland-protocols governance]
document has been accepted, which means there are now clear processes to
introduce new protocols and make changes to existing ones. GitLab merge
requests are now used and CI is in place.

I've also worked on [python-emailthreads], the library that powers SourceHut's
patch review UI. I fixed the unit tests, introduced new tests and fixed the
bugs discovered by tests.

I figured out what caused quite a few crashes on output hotplug in wlroots.
In Sway, I've added [auto-detection of output scale][sway-auto-scale], so your
laptop's HiDPI monitor should just work without any configuration.

In the next few weeks I'll continue working on koushin, libliftoff and mrsh.
Thanks to a generous contributor I also got my hands on a FreeSync monitor, so
expect some updates in this area as well!

[joined-sourcehut]: https://emersion.fr/blog/2019/working-full-time-on-open-source/
[wxrc]: https://git.sr.ht/~sircmpwn/wxrc
[koushin]: https://git.sr.ht/~emersion/koushin
[migadu]: https://www.migadu.com/en/index.html
[libliftoff]: https://github.com/emersion/libliftoff
[glider]: https://github.com/emersion/glider
[glider-early-bench]: https://octodon.social/@emersion/103300395120210509
[FOSDEM libliftoff talk]: https://fosdem.org/2020/schedule/event/kms_planes/
[mrsh]: https://mrsh.sh
[wayland-protocols governance]: https://gitlab.freedesktop.org/wayland/wayland-protocols/blob/510188250ea8fa1065b060ea91a9abfab87b7c2e/GOVERNANCE
[python-emailthreads]: https://github.com/emersion/python-emailthreads
[sway-auto-scale]: https://github.com/swaywm/sway/commit/2f84d6e349d12f3293c44268bc5c8551340e5787
