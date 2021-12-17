+++
date = "2021-12-17T00:00:00+02:00"
title = "Status update, December 2021"
slug = "status-update-36"
lang = "en"
tags = ["status update"]
+++

Hi! Last month has been pretty action-packed, so we got a lot to cover in this
status update. Let's settle in, grab a cup of tea, and see what's in store.

Today I released the long-awaited [wlroots 0.15.0]. This is a pretty massive
release with lots of new features and architectural changes, I don't even know
where to start. Simon Zeni and I have reworked the renderer and backend API,
making it a lot more flexible and removing a lot of arbitrary limitations.
Kirill Primak has improved the surface API, fixing a lot of subtle bugs and
preparing future work for better state synchronization. Isaac Freund and
Devin J. Pohly have added features to the brand new scene-graph API. And many
other contributors have sent various patches. Thanks everyone!

This new wlroots release comes with an implementation of [linux-dmabuf feedback]
(previously linux-dmabuf hints). I've been working on this protocol addition
for a while (2 years!), it's nice to finally see it shipped. Because the
problem space is so large and many different hardware and software setups need
to be accounted for, it took quite a bit to end up with a good design. The
protocol allows compositors and clients to negotiate the best GPU and buffer
properties to use for the best performance. On the short term, zero-copy
fullscreen should work a lot more reliably. On the long term, there are
numerous optimization opportunities to better support KMS planes and multi-GPU
setups, among other things.

In other Wayland news, earlier this month I've released [Wayland 1.20.0]. The
main new feature is first-class FreeBSD support, with proper continuous
integration to make sure we don't regress it. There are a few protocol
additions: `wl_output.name` and `description` makes it easier for clients to
identify output devices, and `wl_surface.offset` removes some weirdness from
`wl_surface.attach`.

Let's switch gears and take a look at the IRC ecosystem. We've officially
launched the [chat.sr.ht public beta], allowing all paid SourceHut users to
easily connect to a hosted soju instance. If you haven't tried it yet, please
give it a shot!

I've wired up [account-registration] support in soju and gamja, so creating an
account on networks which support this extension is now child's play.
Unfortunately most networks don't support it yet, fixing this will be my next
focus. soju now falls back to an alternate nickname if the configured one is
already taken, so it should be easier to experiment with the bouncer even if
already connected from another IRC client. I've finally got around to adding
exponential backoff to soju's reconnection attempts to make it less noisy.

I've posted 2 new drafts for new IRCv3 specifications. The [WHOX] draft
documents an existing but undocumented de-facto extension of the `WHO` command.
With WHOX, clients can request extra metadata about other users such as account
names, or request only a subset of the metadata. The other new draft
standardizes [DNS SRV records for IRC]. This makes it so IRC clients can
connect to addresses such as "libera.chat" (note the missing "irc." prefix)
without hitting errors. At the moment, this results in timeouts and confuses
users.

Let's close this status report with 3 small new projects. [gqlclient] is a new
GraphQL client library, but unlike others it uses code generation to reduce
boilerplate and improve type safety. GraphQL can feel intimidating at first, I
hope this library can make it easier to write small programs interacting with
sr.ht services.

This brings us to the second project, [hut]. It's a CLI companion utility for
sr.ht. Right now it's still pretty barebones: it can only create new pastes,
submit build jobs and [follow their output][hut follow]. A lot of useful
features could be added, such as attaching artifacts to Git tags or listing
pending patches on the mailing list. As always, patches welcome!

Last but not least, [gyosu] is a C documentation generator. I don't like
existing solutions like Doxygen and Sphinx, so it was only a matter of time
before I start working on a replacement. Again, this project is still in the
early stages: it can handle the basics of parsing headers and spitting out
HTML, but still lacks proper linkification, basic syntax highlighting and
proper CSS styling.

I think that's all for this month. I may have forgotten some things but I'm
running out of ink. Next month I'll focus on the upcoming Sway release, but
I'll also take 2 weeks off, so should be more quiet. See ya!

[wlroots 0.15.0]: https://gitlab.freedesktop.org/wlroots/wlroots/-/releases/0.15.0
[linux-dmabuf feedback]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/8
[Wayland 1.20.0]: https://lists.freedesktop.org/archives/wayland-devel/2021-December/042064.html
[chat.sr.ht public beta]: https://sourcehut.org/blog/2021-11-29-announcing-the-chat.sr.ht-public-beta/
[account-registration]: https://ircv3.net/specs/extensions/account-registration
[WHOX]: https://github.com/ircv3/ircv3-specifications/pull/482
[DNS SRV records for IRC]: https://github.com/ircv3/ircv3-specifications/pull/483
[gqlclient]: https://git.sr.ht/~emersion/gqlclient
[hut]: https://git.sr.ht/~emersion/hut
[hut follow]: https://asciinema.org/a/s4Eba7Yza6gSYLhypBUjStUnp
[gyosu]: https://git.sr.ht/~emersion/gyosu
