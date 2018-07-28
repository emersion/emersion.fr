+++
date = "2018-07-29T00:00:00+01:00"
title = "Status update, july 2018"
slug = "status-update-2"
lang = "en"
tags = ["status update"]
+++

Here we are again, a month has passed. While this month has been quieter
relative to [June][prev-status] in terms of new projects, a few cool things
still happened, and I'll describe them in this post.

In the sway/wlroots universe, I mostly fixed some bugs and reviewed a lot of
pull requests (in fact, 69 pull requests). We've shipped another alpha release,
and our focus is now [the first beta][sway-beta-1]. We're getting there! Apart
from these, I've put some effort into an improved
[gamma control][wlr-gamma-control] protocol: the current version is undocumented
and has issues with big gamma tables.

I've released a [new version of mako][mako-1.1], which now supports criteria!
This means you'll be able to style differently urgent notifications,
notifications coming from your e-mail client, the hidden notifications
placeholder or a more complicated combination of those. I've also merged a few
[slurp] patches: it's now possible to customize the appearance of the
region picker, including colors and displaying the region's position and size.
Finally I've added support for the [screencopy] protocol to [grim], which brings
better performance.

If you missed it, my [xdg-decoration] protocol has been merged in
`wayland-protocols`! That's very good news, that means we now have a standard
way of negociating SSD. I expect various projects to gradually add support to
this protocol. The Arch package has just been updated a few hours ago, so
my [wlroots pull request][wlroots-xdg-decoration] will probably be able to be
merged fairly soon. For instance, the Smithay guys already have a
[pending pull request][smithay-xdg-decoration] to support it.

I've submitted an [Xwayland patch][xwayland-patch] to fix pointer input
issues on transformed outputs (outputs rotated by 90 degrees for instance).
Alongside with this patch I also changed the description in the `xdg-output`
protocol to make sure the transformed outputs case is correctly understood, and
changed the description of the `wl_output` interface to allow omissions of the
physical size (for projectors and virtual outputs). While these are small prose
changes, I think they are still important.

[mrsh] has recently received some love. The parser has been rewritten, it used
to closely follow the POSIX spec expectations relative to lexing and it resulted
in convoluted code. Hopefully this new simple recursive descent parser can be
more readable while still being compatible with the spec. I've also added some
clean abstractions for tasks with the help of sircmpwn. This design is able to
handle nested asynchronous and synchronous operations, which is neat. That means
things like `echo abc | cat >out` and `{ sleep 5; echo hey; } & ls` now work as
expected. I think I'm going to focus on job control and variable expansion next.

I've also improved my [Web Key Directory Go library][go-openpgp-wkd]. In short,
[WKD][wkd] specifies a standard way to distribute public keys for a domain. The
GPG utility supports it and I think it's a handy alternative to classic public
key servers. Since I use the [Caddy][caddy] web server, I've created
[a very simple plugin][caddy-wkd] to ease the setup process.

And one last upgrade: I've added [LMTP][lmtp] support to the server part of
[go-smtp], this allows the library to be used for local mail delivery.

I think that's it! I'll do my best to continue to work on these projects. I've
some thoughts about mail servers so I might end up messing with some of my Go
email-related libraries. I'd also like to do some renderer work in wlroots, for
instance improving the multi-planar image support. We'll see how this goes!

[prev-status]: https://emersion.fr/blog/2018/status-update-1/
[sway-beta-1]: https://github.com/swaywm/sway/milestone/1
[wlr-gamma-control]: https://github.com/swaywm/wlroots/pull/1157
[mako-1.1]: https://github.com/emersion/mako/releases/tag/v1.1
[slurp]: https://github.com/emersion/slurp
[screencopy]: https://github.com/swaywm/wlr-protocols/blob/master/unstable/wlr-screencopy-unstable-v1.xml
[grim]: https://github.com/emersion/grim
[xwayland-patch]: https://gitlab.freedesktop.org/xorg/xserver/commit/ce2dde9ed0243a18ae18af0879134f7c1afbd700
[mrsh]: https://github.com/emersion/mrsh
[go-openpgp-wkd]: https://github.com/emersion/go-openpgp-wkd
[wkd]: https://tools.ietf.org/html/draft-koch-openpgp-webkey-service-06
[caddy]: https://caddyserver.com/
[caddy-wkd]: https://github.com/emersion/caddy-wkd
[lmtp]: https://tools.ietf.org/html/rfc2033
[go-smtp]: https://github.com/emersion/go-smtp
[xdg-decoration]: https://github.com/wayland-project/wayland-protocols/commit/76d1ae8c65739eff3434ef219c58a913ad34e988
[wlroots-xdg-decoration]: https://github.com/swaywm/wlroots/pull/1053
[smithay-xdg-decoration]: https://github.com/Smithay/client-toolkit/pull/20
