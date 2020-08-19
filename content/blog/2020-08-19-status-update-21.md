+++
date = "2020-08-19T00:00:00+02:00"
title = "Status update, August 2020"
slug = "status-update-21"
lang = "en"
tags = ["status update"]
+++

Hi! Regardless of the intense heat I've been exposed to this last month,
I've still been able to get some stuff done (although having to move out to
another room which isn't right under the roof).

I've worked a lot on IRC-related projects. I've added a `znc-import` helper to
[soju] to ease migration from ZNC: this tool will read the ZNC configuration
file and fill soju's database with users, networks and channels. A simple
built-in [ident] server is now included and allows upstream servers to
correctly apply rate limits to each bouncer user, instead of applying them to
the whole bouncer. Chat history support has been improved, with support for the
`CHATHISTORY AFTER` command. I've also got rid of the in-memory ring buffer
used to push chat history to clients that don't support the IRCv3 chat history
extension. Instead, soju now reads history from log files.

My next plans are to improve message delivery reliability (no more lost
messages when the network goes down!), implement rate limiting and then start
working on [better support][soju namespace] for connecting to multiple upstream
server via a single connection to the bouncer.

[gamja] has seen a number of improvements too. Some WeeChat-like keybindings
are now supported, bbworld1 has implemented proper error reporting (thanks!),
date separators make it clearer when a day passed and message highlights now
stand out.

In Wayland news, I've finally finished my [renderer v6] pull request, with all
features implemented. Thanks to early testers we found a few regressions
(including an [iris bug]) and issues with compositors like Wayfire. This has
been pretty helpful, and I'll work on fixing the last remaining bugs.

I've been continuing work on Valve's [gamescope] project too. This mostly boils
down to investigating nasty bugs in gamescope itself, Xwayland, RADV, Mesa's
Vulkan X11 window system integration, winex11 and other parts of the graphics
stack. I'm glad some of this work will be useful to the wider Wayland
ecosystem.

Last, I've been preparing my talk for XDC 2020 about buffer constraints, but
more on that later -- maybe next month! See ya!

[soju]: https://soju.im/
[soju namespace]: https://todo.sr.ht/~emersion/soju/16
[ident]: https://en.wikipedia.org/wiki/Ident_protocol
[gamja]: https://sr.ht/~emersion/gamja/
[renderer v6]: https://github.com/swaywm/wlroots/pull/2240
[iris bug]: https://gitlab.freedesktop.org/mesa/mesa/-/issues/3425
[gamescope]: https://github.com/Plagman/gamescope
