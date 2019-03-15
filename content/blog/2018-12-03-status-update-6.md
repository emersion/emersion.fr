+++
date = "2018-12-03T00:00:00+02:00"
title = "Status update, November 2018"
slug = "status-update-6"
lang = "en"
tags = ["status update"]
+++

This month has been focused on sway mostly. We've released [sway 1.0-beta.2],
which brings a myriad of bugfixes and small enhancements. This is also the first
release compatible with Firefox Nightly running with native Wayland. There are
still some minor bugs but it's overall pretty stable. If you want to try it,
install Nightly and run it with `GDK_BACKEND=wayland`!

A lot of i3 4.16 features have been implemented in this release, like
`strip_workspace_name` and `title_align`. Many new options let you customize
sway further, for instance by tweaking the scroll speed or setting titlebar
padding. Big thanks to all contributors!

Let's continue with new relases: [mako 1.2] has been published. This version
adds elogind support for users not using systemd. Just like sway, a bunch of new
customization options are available: size and margins in criteria, per-side
padding, centering notifications. Notifications coming from clients not
supporting markup are now displayed better (the spec is annoyingly not very
clear about this).

To end this release party, let's just mention that [grim] 1.0 and [slurp] 1.0
are now available. No major changes here, it's just the first release. Note that
Arch users can now install the `grim` package from the community repo.

mrsh development is still moving forward, little by little. Functions have been
implemented by Drew Devault and the `umask` builtin by benofbrown (thanks!).
Redirecting a builtin's output now works (since builtins are not spawned in
separate processes, we need to have special cases for those). Another notable
addition is support for profiles, now mrsh can be used as a login shell!

I also spent quite some time trying to understand what was going on with a
[weird bug][mrsh issue 48]. After executing command substitution (for instance,
`ls $(cat file)`), the next commands were executed twice. In fact, they were
read twice from stdin. After discussing with the musl folks, I realized libc
has some exit handlers for `FILE *` objects: it tries to rewind the file
descriptor if it has some data in its internal buffer. Eh, I didn't expect that!
To fix this, I ended up removing all `FILE *` usage by switching to plain file
descriptors.

Before wrapping up this status report, let me introduce you [kanshi]. It's an
output configuration daemon that dynamically switches between, ugh,
configurations. I personally use it to turn off my internal laptop screen when
docked (and turn it back on again when undocked). It's still pretty unstable,
please contribute to make it better! Once is not custom, it's written in Rust.

In December I'll continue some wlroots work to refactor the clipboard and
drag-and-drop code (it needs some love!). I've started to look how to implement
job control in mrsh, I'd like to complete this work (it's currently not working,
and it's not easy to debug). We'll see how this goes. Thanks for reading!

[sway 1.0-beta.2]: https://github.com/swaywm/sway/releases/tag/1.0-beta.2
[mako 1.2]: https://github.com/emersion/mako/releases/tag/v1.2
[grim]: https://github.com/emersion/grim
[slurp]: https://github.com/emersion/slurp
[mrsh issue 48]: https://github.com/emersion/mrsh/issues/48
[kanshi]: https://github.com/emersion/kanshi
