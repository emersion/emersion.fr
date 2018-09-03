+++
date = "2018-08-29T00:00:00+02:00"
title = "Status update, august 2018"
slug = "status-update-3"
lang = "en"
tags = ["status update"]
+++

Time for the third status update! It's been an interesting month, with good
progress for mrsh as well as some cool sway/wlroots and matcha stuff.

Let's have a look at my main focus for August: mrsh. It's a POSIX shell library
designed to be minimal (no more than POSIX), simple (read "readable"!) and
could be used as a base for more elaborate shells and other tools.

I've been helped by [sircmpwn](https://drewdevault.com/), who has added in a few
builtins (like `set`) and special parameters by sending patches on the
[mailing list][mrsh-ml]. Thank you!

[mrsh-ml]: https://lists.sr.ht/%7Eemersion/public-inbox

Speaking of parameters, variables are now supported, as well as word expansions.
This includes parameter expansion (like `$HOME` and `${var:-default}`) and
command substitution (like `` echo `date` ``). Tilde expansion (`echo ~root`),
field splitting and pathname expansion (`echo *`) are implemented, but some work
remains to correctly handle all situations.

I've added here-documents support, which have a few variations otherwise it
wouldn't be fun (`<<` vs `<<-`, `<<EOF` vs `<<'EOF'`). In the shell, these are
exposed as in-memory files.

Aliases are now working, but I'm still searching for ways to make them better.
Since they behave as macros at the parser level, I'm not sure how to handle them
relative to line number information.

I've also added line number information to the AST (more precisely, offset +
line + column numbers). These new features are demonstrated by a little
`highlight` example that reads a shell script from the standard input and prints
a highlighted version. For instance:

![The highlight example in action](https://sr.ht/iJ3C.png)

I've tried to design this with linters and formatters in mind: it should be
possible to e.g. preserve whitespace while transforming the AST. There's still
some work needed to better handle comments and continuation lines.

All in all, the parser is pretty close from being complete and only a few Hard
Issues™ are remaining for the shell itself. The parser is mostly missing
arithmetic expansion and a few control structures. If you want to track the
overall project status I maintain a [detailed issue][mrsh-status] for this
purpose.

[mrsh-status]: https://github.com/emersion/mrsh/issues/8

In the sway and wlroots universe, we've been working on a [new gamma control
protocol][gamma-control]. The old one had issues with large gamma tables on
some hardware, and we've taken advantage of this opportunity to add in some
other minor improvements. I've been working on a [clipboard manager
protocol][clipboard-manager], but this is still work-in-progress.

[gamma-control]: https://github.com/swaywm/wlroots/pull/1157
[clipboard-manager]: https://github.com/swaywm/wlr-protocols/pull/25

There are also good news from Qt: they've [implemented][qt-xdg-decoration] the
`xdg-decoration` protocol for server-side window decorations.

[qt-xdg-decoration]: https://codereview.qt-project.org/#/c/235936/

Finally, I've been pushing a few commits to [matcha], a very simple Git
read-only web interface. It can now [serve multiple repositories]
[matcha-multiple-repos] and supports [server-side syntax highlighting]
[matcha-syntax]. My friend Jean Thomas has been creating a [RPM package]
[matcha-rpm] to ease deployment on Fedora.

[matcha]: https://github.com/emersion/matcha
[matcha-multiple-repos]: https://github.com/emersion/matcha/commit/1f48c752a45bd2f21e1c58a145a54404937b3e33
[matcha-syntax]: https://github.com/emersion/matcha/commit/d21e143baaa1ffb35e2ba28e2190bfc7520790a7
[matcha-rpm]: https://github.com/jeanthom/matcha-rpm

EOF. Let me know if you want to contribute to one of these projects! In any
case, see you next month!
