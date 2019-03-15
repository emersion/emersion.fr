+++
date = "2018-10-02T00:00:00+02:00"
title = "Status update, September 2018"
slug = "status-update-4"
lang = "en"
tags = ["status update"]
+++

Hi all! This update comes a little bit late, because I've been busy with
[XDC 2018][xdc2018] last week. I also wanted to publish at least one
non-status-update blog post before this one, but… Erm, well, let's talk about
XDC!

XDC is a conference organized by X.Org. It's not really about the X11 server,
the scope of the event is broader (in fact most people there were into graphics
drivers and lower-level stuff).

I met there Drew, Markus, Scott and Guido who are all members of the wlroots
crew. It was good meeting them, apart from Drew it was the first time I've
seen them! I discussed a lot with other XDC attendees too, leading to me
realizing we need to improve our DRM backend. Some discussions were very
helpful, because people took the time to explain how to handle faulty
DisplayPort cables or if our current damage tracking implementation was correct.
We also talked about Multi-Stream Transport, hotplugging graphics cards and
FreeSync which would be cool features to have in wlroots (we _should_ already
support MST, but I've been told it needs a few fixes to work properly).

Another discussion was about [presentation-time], a Wayland protocol to provide
feedback about the exact time at which a frame has been displayed to the user.
This is useful for games, video players and medical software, all of which
require very precise presentation timestamps. Talking with actual people
needing this protocol helped to make me [implement it on the plane back to
France][wlroots-presentation-time], because it suffered from a chicken-and-egg
problem: no one was using it because it wasn't available outside Weston.

There were also some interesting talks. One was about VKMS which would allow us
to test our DRM implementation more easily by emulating a graphics driver.
Others included the Intel CI for Mesa, a rewrite of the Intel driver (to use
Gallium) and an introduction to Intel assembly language for graphics cards. Cool
stuff!

Apart from XDC (and earlier in the month), I've been trying to make wlroots work
well in case more outputs are connected than supported by the graphics card (ie.
there are more enabled connectors than CRTCs). Starting from Not Working At
All™, I finally got everything working on the wlroots side, though some more
work is needed on the sway side to make everything smooth. I also started to
work again on [kanshi], which I use to configure my outputs. We also managed to
merge Laaas' [pointer-constraints][wlroots-pointer-constraints] pull request.
With the work-in-progress [relative-pointer][wlroots-relative-pointer] pull
request, this should allow us to have a way better gaming experience on sway!

We also have good progress for mrsh. Drew and other contributors helped a lot
this month, thanks! I almost completed the parser, I just need to add in
arithmetic expressions support. The AST is now annotated with more precise
positions and the highlighter example has been improved. A lot of builtins are
now supported, including `cd`, `.`, `eval`, `shift`, `export`, `pwd`, `true`.
The shell supports subshells and `for`/`while` loops. We also have some harness
tests (and the beginning of conformance tests). We're pretty close to having a
usable shell here! There's still a lot to be done, so if you're interested, ping
me on IRC or by email.

Damn, this status update is getting pretty long. Let's mention [go-openpgp-hkp],
a Go library I've created to create OpenPGP HTTP Keyserver Protocol clients and
servers. I've been pushing fixes to [go-dkim], its behavior is now in line with
the existing DKIM tools (even if it's not strictly in line with the RFC).

All right, that's enough! See you in a month (or less if I somehow manage to
publish another article by then), and if you have questions/comments send
everything to my [public inbox][public-inbox].

[xdc2018]: https://xdc2018.x.org/
[presentation-time]: https://github.com/wayland-project/wayland-protocols/tree/master/stable/presentation-time
[wlroots-presentation-time]: https://github.com/swaywm/wlroots/pull/1272
[kanshi]: https://github.com/emersion/kanshi
[wlroots-pointer-constraints]: https://github.com/swaywm/wlroots/pull/852
[wlroots-relative-pointer]: https://github.com/swaywm/wlroots/pull/1274
[go-openpgp-hkp]: https://github.com/emersion/go-openpgp-hkp
[go-dkim]: https://github.com/emersion/go-dkim
[public-inbox]: https://lists.sr.ht/~emersion/public-inbox
