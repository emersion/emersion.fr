+++
date = "2018-06-24T00:00:00+01:00"
title = "Status update, june 2018"
slug = "status-update-1"
lang = "en"
tags = ["status update"]
+++

A lot happened this month. I'm usually used to focus on a single project for
extended amounts of time, but this month was different. While continuing to
frequently review and send patches to my "big projects" (such as [wlroots]), I
also started a bunch of little side projects. I'm going to try to sum up all
of this in this post, I feel like stepping back could help driving me forward
next month.

First, what's up with [wlroots]? I've been working on a new type,
[`wlr_buffer`][wlr_buffer].
It offloads some complexity off of `wlr_surface`, fixes some bugs that caused
glitches and enables new use-cases. I won't be able to go into details, because
buffer and surface management on Wayland is complicated: you have different
buffer types (shared memory in RAM vs. zero-copy buffers in the GPU) which
have different semantics (some need to be uploaded to the GPU, with damage
tracking support), and on top of that you also need to handle synchronization
(which also depends on the buffer type) and cleanup (when the buffer is
removed). Anyway, `wlr_buffer` allows for [atomic layout] and animations when
closing windows (used by [Wayfire][wayfire]). I'm still
[continuing this work][redesign surface state] and improving the `wlr_surface`
API.

Another Big Thing is the [`export-dmabuf` protocol][export-dmabuf]. We've been
working with atomnuker, who has a ffmpeg background, to design an efficient
protocol to capture your screen. It's using DMA-BUFs under the hood, which means
that clients can directly read the screen contents without needing to copy
anything. This will be useful for screen recording and screencasting, we already
have a working — even if somewhat arcane — screen recorder (which is able to use
hardware-accelerated video encoding!). I'm still working on
[another protocol][screencopy] to cover the cases where `export-dmabuf` either
doesn't work or is overkill.

I've also sent another iteration of the [`xdg-decoration`][xdg-decoration]
protocol for inclusion in wayland-protocols. This protocol allows the compositor
and clients to negociate server-side decorations for better system integration.
Getting a protocol right takes an insane amount of time, even for a very simple
one like this one!

Outside of the sway world, stuff happened too. vil has been working on [mako],
my Wayland notification daemon, to add criteria support. This means you can now
style differently notifications depending on the app they come from, their
urgency, or even their category.

A new contributor, freemountain, has started to work on my Twitter → Mastodon
bridge project, [emuarius]. The goal of this project is to be able to follow
Twitter accounts from Mastodon, and to be able to interact with them seamlessly.
The "follow Twitter users from Mastodon" part isn't too far from working, but
still [has bugs][emuarius-bug]. It's also using the legacy OStatus standard,
we'll eventually need to migrate to ActivityPub.

Now to the new projects. I've started [mrsh], a new shell. I want to build
a simple and minimal library for POSIX shells. Existing projects, even [dash],
aren't cut for this job. My workflow so far has been to get a subset of each
feature working, to prove that the approach is viable, and organically grow the
feature set when the full chain is operational. So far I've got a subset of the
parser/AST and a subset of the command handling working. My next focus will be
job control and variable expansion. I'm not yet happy with the parser, I'll try
to make it nicer (the POSIX standard doesn't help with that).

Another project I've been working on is [emailthreads]. My friend sircmpwn is
working on [sr.ht][srht], an open-source collection of services to manage
software projects. We've been discussing about the best way to submit patches
and review them. We've been wondering if it'd be possible to design an
easy-to-use interface for `git-send-email`. emailthreads' job is to parse
replies to emailed patches into a tree of comments to allow them to be displayed
in a web interface. To my own disappointment, it has been working
[pretty well][emailthreads-output-example] so far on real-world test cases. I
still think it won't ever be perfect because there are too many edge cases, but
I'm looking forward to testing it on more discussions!

Last, I've bootstrapped [wleird], a collection of weird Wayland clients that use
obscure Wayland features in counter-intuitive or uncommon ways. Test clients are
lacking when implementing the compositor side of Wayland protocols. There are
only two test clients so far, one using subsurfaces and the other buffer
positions, but they both don't work (yet) on wlroots. We also have ideas for
more weird clients!

What a busy month! And I've not even mentionned the few patches I've pushed or
reviewed for [matcha], [slurp], [grim] and [go-imap][go-imap-move]. Anyway, I'm
looking forward to even more awesome stuff next month. If you're interested in
any of these projects, make sure to drop me an email or ping me on IRC!

[wlroots]: https://github.com/swaywm/wlroots
[wlr_buffer]: https://github.com/swaywm/wlroots/pull/1050
[atomic layout]: https://github.com/swaywm/sway/pull/2072
[wayfire]: https://github.com/ammen99/wayfire
[redesign surface state]: https://github.com/swaywm/wlroots/pull/1076
[export-dmabuf]: https://github.com/swaywm/wlroots/pull/992
[screencopy]: https://github.com/swaywm/wlroots/pull/1069
[xdg-decoration]: https://lists.freedesktop.org/archives/wayland-devel/2018-June/038523.html
[mako]: https://github.com/emersion/mako
[emuarius]: https://github.com/emersion/emuarius
[emuarius-bug]: https://github.com/emersion/emuarius/issues/7
[mrsh]: https://github.com/emersion/mrsh
[dash]: http://gondor.apana.org.au/~herbert/dash/
[emailthreads]: https://github.com/emersion/python-emailthreads
[srht]: https://meta.sr.ht/
[emailthreads-output-example]: https://github.com/emersion/python-emailthreads/blob/master/test/data/multiple-replies/output3.txt
[wleird]: https://github.com/emersion/wleird
[matcha]: https://github.com/emersion/matcha
[slurp]: https://github.com/emersion/slurp
[grim]: https://github.com/emersion/grim
[go-imap-move]: https://github.com/emersion/go-imap-move
