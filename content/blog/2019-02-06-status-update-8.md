+++
date = "2019-02-06T00:00:00+02:00"
title = "Status update, january 2019"
slug = "status-update-8"
lang = "en"
tags = ["status update"]
+++

This blog post should be named "Status update, january 2019, plus FOSDEM". This
was my first FOSDEM! I've been there together with Drew DeVault who's published
[a nice, detailed summary about it][ddevault-fosdem]. Mine will be much shorter
(note: this is an allegory).

Best thing about FOSDEM is that you get to meet **lots** of people: Arch Linux,
FreeBSD, KDE, PipeWire, Purism, Wayland and a lot more. I feel it's been really
productive and hope it'll bootstrap some initiatives and collaboration in the
future! The sr.ht and sway meetings have both been super-cool, big thanks to
everyone who participated!

This month has mostly been sway and wlroots focused, with lots of bug fixes to
get ready for [1.0-rc.1][sway-1.0-rc.1]. Notably, I've finally got to make sway
work properly with my laptop dock. My laptop only supports two screens at a time
so some patches were needed to make it properly handle three (two enabled, one
disabled). I also spent some time refactoring the wlroots clipboard code, to
make it clearer, easier to maintain and more in line with the spec. Next up is
drag-and-drop!

mrsh job control is still in-progress. I've put together a [minimal job control
shell][minishell] which works, now I _just_ need to integrate it into mrsh. It's
a little tricky and hard to debug, so I'll need a little more time (but we'll
get there eventually!). More exciting news include many arithmetic expansion
improvements by Cristian A. Ontivero and macOS support by Martin Kühl. Thanks!

I've worked a little on [maddy], my email server project. It's now possible to
use it for development purposes, for instance when working on [lists.sr.ht]:

```
smtp://127.0.0.1:1025 {
	proxy lmtp+unix:///tmp/lists.sr.ht-lmtp.sock
}
```

The next step will be a to implement a multiplexer, to be able to filter
incoming emails (e.g. forward emails for `@lists.sr.ht`, store them otherwise).

Thanks for reading and see you in a month!

[ddevault-fosdem]: https://drewdevault.com/2019/02/05/FOSDEM-recap.html
[sway-1.0-rc.1]: https://github.com/swaywm/sway/releases/tag/1.0-rc1
[minishell]: https://git.sr.ht/~emersion/minishell
[maddy]: https://github.com/emersion/maddy
[lists.sr.ht]: https://lists.sr.ht
