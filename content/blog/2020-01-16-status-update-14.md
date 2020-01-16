+++
date = "2020-01-16T00:00:00+02:00"
title = "Status update, January 2020"
slug = "status-update-14"
lang = "en"
tags = ["status update"]
+++

This month's status update will be a little lighter than usual due to Christmas
holidays. I've still got the chance to send a patches to quite a few projects,
and… do a lot of releases! Weston, Wayland, Sway, mako and grim all have or
will get a release this month.

The new [mako] release allows you to run notification actions with a new
`makoctl menu` command, adds a new `--config` CLI flag to specify a custom
config file path, and improves touch-screen support. On the master branch,
I've also worked on adding a `makoctl set` command to change config options
on the fly. This allows users to implement a "do not disturb" mode that can
be enabled with a keybind, for instance. There are still some
[design issues][makoctl set issues] with this approach, some more discussion
is needed (thanks Bill Doyle for the great feedback!).

The new [grim] release makes the destination file argument optional: running
`grim` will now drop a timestamped file in `$XDG_PICTURES_DIR`. Apart from this
feature, a few bugfixes are included. At this point grim is mostly "done", I
don't expect any new major feature. This is how I like software maintenance:
boring releases, minor features from time to time.

In other Wayland news, I've continued to work on [libliftoff]. My experimental
libliftoff-based [glider] compositor received a number of bugfixes, and I've
taken some time to take a step back and think about the overall design.

I've started working on two big wlroots pull requests. The former [adds a new
`wlr_output_layer` API][wlroots output-layer] which will expose hardware planes
to compositors, paving the way for performance and battery usage improvements.

The latter [adds a new scene-graph API][wlroots scene-graph]: this will reduce
the amount of work compositors need to do in case they don't want anything out
of the ordinary. These compositors will be able to take advantage of hardware
planes and support things like explicit synchronization without any extra work.
If they want to do something fancy, compositors will still be able to go
lower-level of course.

I've been starting some [adaptive sync/variable refresh rate work][wlroots vrr]
too. What's still missing is the Sway part, which has complicated implications
due to the interaction with [repaint scheduling][sway repaint scheduling]. I
have a plan, I'll see if it works in practice. I want to make sure the feature
works as expected, so I'll probably create a test client (or patch
`weston-presentation-shm`). After all of that is done, I'll be able to draft a
Wayland protocol to let clients opt-in for adaptive sync and send it for review
to wayland-protocols. Soon™!

In [mrsh] news, progress has been continuing slowly but steadily. `trap(1)`
and `exec(1)` have been mostly implemented. Various bugfixes have been pushed.
And Drew DeVault has started [imrsh], short for _interactive mrsh_. This is the
simple, interactive POSIX shell we've all been waiting for!

Work on the [koushin] webmail has continued, with most of the hard problems
tied to the plugin infrastructure solved. I've been focusing on hot reload,
HTML e-mails and CardDAV support. While working on CardDAV, I realized Go is
lacking a good WebDAV library. WebDAV is tricky to implement in Go, because
the standard library's `encoding/xml` package requires you to know in advance
the complete structure of the XML document you're going to parse. This doesn't
play well with WebDAV's extensibility. Third-party XML libraries don't support
namespaces properly, which is a no-go when juggling between WebDAV's and
CardDAV's. I've finally found a reasonable way to make `encoding/xml` work by
[delaying the parsing process][go-webdav rawxmlvalue] for unknown XML elements.
I've started writing a new [WebDAV library][go-webdav] based on this. It can
already fetch address books from a CardDAV server and serve a read-only WebDAV
filesystem. I'll expand the library as I need more features.

That's all for today, see you next month!

[mako]: https://github.com/emersion/mako
[grim]: https://github.com/emersion/grim
[makoctl set issues]: https://github.com/emersion/mako/issues/138
[libliftoff]: https://github.com/emersion/libliftoff
[glider]: https://github.com/emersion/glider
[sedna]: https://git.sr.ht/~sircmpwn/sedna
[grim]: https://github.com/emersion/grim
[mrsh]: https://mrsh.sh
[imrsh]: https://git.sr.ht/~sircmpwn/imrsh/
[wlroots scene-graph]: https://github.com/swaywm/wlroots/pull/1966
[wlroots output-layer]: https://github.com/swaywm/wlroots/pull/1985
[wlroots vrr]: https://github.com/swaywm/wlroots/pull/1987
[sway repaint scheduling]: https://github.com/swaywm/sway/pull/4588
[koushin]: https://git.sr.ht/~emersion/koushin
[go-webdav]: https://github.com/emersion/go-webdav
[go-webdav rawxmlvalue]: https://github.com/emersion/go-webdav/blob/56c162197b673cd5b7b1c8841e3e2ac620a0f6b5/internal/xml.go
