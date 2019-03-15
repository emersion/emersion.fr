+++
date = "2019-03-08T00:00:00+02:00"
title = "Status update, February 2019"
slug = "status-update-9"
lang = "en"
tags = ["status update"]
+++

Hi, time for February's status update!

Once again this month I've worked a lot on sway and wlroots. We're getting
closer to 1.0 with each RC and I see fewer and fewer crash reports. We still
have a couple of bugs to iron out, but we're almost there!

Apart from reviewing pull requests, I've finished refactoring and fixing a lot
of drag-and-drop bugs. It should now work a lot better than before. I've also
taken the time to cleanup and refactor a lot of the rootston code (wlroots'
reference compositor). In particular the [views abstractions][rootston-views]
and the [rendering code][rootston-render] have been rewritten. Next up is the
input code (rootston's input code is well-known for being especially shitty!).

I've also learnt new things by adding proper FreeBSD support to [builds.sr.ht].
The FreeBSD community has been very helpful and was very pleasant to work with.
Dave Cottlehuber wrote [a very helpful script draft][freebsd-notes] to build a
bootable FreeBSD image from scratch in an automated fashion. From these notes
I wrote a little [`genimg`][freebsd-genimg] script suitable for builds.sr.ht,
and voilà, we now have 11.x-RELEASE, 12.x-RELEASE and 13.x-CURRENT FreeBSD
images!

Thanks to the work of Bill Doyle and Anton Älgmyr, the [mako] notification daemon
has gained support for [grouping][mako-grouping] and can now display
[icons][mako-icons]. That's pretty awesome, expect a new release soon-ish.
[slurp] has been improved too: Yorick van Pelt has made it so the tool exits
when <kbd>Esc</kbd> is pressed and improved multi-monitor support, while
Ridan Vandenbergh has added a `-f` flag to set the print format.

I'm currently working on some [lists.sr.ht] stuff and e-mail related things in
addition to sway, but I'll write about this in the next status report (hint
hint: make sure to read it!). I'm also working for [Purism] on a cool Wayland
project, I'll write a little post about it in the next few weeks (hint hint:
stay tuned!).

Thanks for reading!

[rootston-views]: https://github.com/swaywm/wlroots/pull/1568
[rootston-render]: https://github.com/swaywm/wlroots/pull/1577
[builds.sr.ht]: https://builds.sr.ht
[freebsd-notes]: https://hackmd.io/s/SJRD7QRNE
[freebsd-genimg]: https://git.sr.ht/~sircmpwn/builds.sr.ht/tree/master/images/freebsd/genimg
[mako]: https://wayland.emersion.fr/mako/
[mako-grouping]: https://github.com/emersion/mako/pull/111
[mako-icons]: https://github.com/emersion/mako/pull/115
[slurp]: https://wayland.emersion.fr/slurp/
[lists.sr.ht]: https://lists.sr.ht
[Purism]: https://puri.sm/
