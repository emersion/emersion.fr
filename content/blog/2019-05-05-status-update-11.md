+++
date = "2019-05-05T00:00:00+03:00"
title = "Status update, April 2019"
slug = "status-update-11"
lang = "en"
tags = ["status update"]
+++

I have great news this month: I finally managed to sit down and work on [mrsh]
job control! It's taken a long time because:

- There is little documentation about how it works. Hopefully the glibc manual
  has been pretty helpful and I managed to get [a prototype][minishell] working.
  I spent some time asking myself existential questions such as "what is a job
  anyway?"[^1].
- It wasn't obvious how to wire everything up with mrsh's architecture. It
  turned out pretty well in the end, but it took several takes.
- It's hard to debug. If you mess up the setup sequence, all you get is a broken
  terminal.

Anyway, the groundwork for job control has landed. You can now start jobs in the
foreground or in the background, interrupt or stop them, and continue them in
the background or foreground (with `fg` and `bg`).

There's still more to be done before job control support is complete. Some tasks
are easy, like adding `kill`/`wait` or completing the `fg`/`bg` implementations.
Some are more involved, for instance we'll need to attach an AST to jobs. In any
case, patches welcome!

Apart from job control, support for `command -v` has been added by dragnel.
Thanks!

In Wayland news, I've become the Wayland and Weston release manager. I hope this
will help the other maintainers since both projects could use more contributors!

I've also been working on wlroots, mainly on refactoring the `wlr_output` API.
The new API looks a lot like `wl_surface`: you attach buffers, set properties
and then apply all pending changes at once. This will allow for many cool
features and will allow us to take advantage of the DRM atomic interface.

The next big change I'm working on is direct scan-out. This will allow wlroots
to skip rendering completely when a fullscreen window is displayed. I've almost
finished implementing it and it works pretty well. Once this is merged I'll be
able to think about planes to skip rendering in more situations.

With vilhalmer we've released a [new mako version][mako-v1.3]. This one brings
a large number of enhancements! New features include grouping, icons, progress
bars and rounded corners. Big thanks to all contributors!

Let's finish this status report with some Go news. I've merged my e-mail
authentication packages into one, [go-msgauth]. It supports DKIM, DMARC and
Authentication-Headers for now, but more features are planned such as ARC.

[maddy] is making steady progress thanks to foxcpp (I have trouble keeping up
with pull requests!). We now have a [man page][maddy-man] which is much better
than the previous README-like file we had. We're still trying to figure out a
good config file format and simple mechanisms.

Alright, see you next month!

[^1]: Contrary to the [POSIX definition][posix-job], it's not just a pipeline as a job is also created with e.g. asynchronous lists

[mrsh]: https://mrsh.sh
[minishell]: https://git.sr.ht/~emersion/minishell
[posix-job]: http://pubs.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap03.html#tag_03_201
[mako-v1.3]: https://github.com/emersion/mako/releases/tag/v1.3
[go-msgauth]: https://github.com/emersion/go-msgauth
[maddy]: https://github.com/emersion/maddy
[maddy-man]: https://github.com/emersion/maddy/blob/master/maddy.conf.5.scd
