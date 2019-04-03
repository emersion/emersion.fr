+++
date = "2019-04-03T00:00:00+03:00"
title = "Status update, March 2019"
slug = "status-update-10"
lang = "en"
tags = ["status update"]
+++

I guess it's already status update time! This month has been pretty busy for me
because I've moved to Finland to work for Intel[^1]. It's been really great so
far, I've been working on automating HDMI/DisplayPort audio testing using
Google's [Chamelium]. I've had plenty of fun talking to the DisplayPort receiver
via I²C and writing C & Python code to automate everything!

One of the first patches I wrote this month were for [lists.sr.ht]. I added a
little DKIM authentication indicator to make sure messages come from where they
say they come from. I'd like to add support for DMARC (which allows domain names
to e.g. require DKIM for all of their outgoing e-mails) and PGP next.

![A DKIM indicator](https://sr.ht/5SX9.png)

Adding this indicator has made us investigate some DKIM failures, so I've also
been working on [go-dkim], my Go library for DKIM. go-dkim now includes a
[milter] (a Postfix mail filter, via [go-milter]) that signs and verifies
e-mails. I've started a [go-dmarc] project to retrieve DMARC policies.

Continuing on Go e-mail stuff, [maddy] has received major updates. [foxcpp] has
been rewriting a lot of the codebase and they've been working on [go-imap-sql],
a SQL backend now used by default by maddy. E-mail servers are complicated and
it's not easy to make them (1) user-friendly and (2) have secure defaults. But
it's an interesting problem and we'll definitely try our best. maddy is now able
to accept new features and already has gained support for local authentication.
Thanks foxcpp for your work!

What would be a status update without some Wayland news? [Martin Peres] has
convinced me that wlroots would benefit a lot from having DRM overlay planes
support. Those would enable the compositor to completely skip compositing in
some cases: for instance if the compositor puts the web browser you're currently
using on a plane, it means that it hands over the web browser's buffers directly
to the graphics driver, without an intermediate copy and without waking up the
GPU (this is called _direct scan-out_). That should improve battery performance
significantly![^2]

So in order to get this feature in wlroots, we first need to revamp the wlroots
API. I've started sending [a few][wlroots-direct-scanout]
[patches][wlroots-format-set] to make it possible. One of the first steps is
adding support for direct scan-out for fullscreen windows only (then we'll be
able to extend this to non-fullscreen windows via overlay planes).

Earlier this month I've also worked on an output management protocol for
Wayland, but this deserves this own blog post so I'll leave it out of this
status update.

That's all for this month, thanks for reading!

[Chamelium]: https://www.chromium.org/chromium-os/testing/chamelium
[lists.sr.ht]: https://lists.sr.ht
[maddy]: https://github.com/emersion/maddy
[go-dkim]: https://github.com/emersion/go-dkim
[go-dmarc]: https://github.com/emersion/go-dmarc
[milter]: https://en.wikipedia.org/wiki/Milter
[go-milter]: https://github.com/emersion/go-milter
[go-message-next]: https://github.com/emersion/go-message/tree/next
[wlroots-format-set]: https://github.com/swaywm/wlroots/pull/1642
[wlroots-direct-scanout]: https://github.com/swaywm/wlroots/pull/1641
[foxcpp]: https://github.com/foxcpp
[go-imap-sql]: https://github.com/foxcpp/go-imap-sql
[Martin Peres]: http://phd.mupuf.org/
[^1]: The opinions expressed on this site are mine alone and do not necessarily reflect the opinions or strategies of Intel Corporation or its worldwide subsidiaries.
[^2]: In fact many phones take advantage of overlay planes, for instance [Android](https://source.android.com/devices/graphics/arch-sf-hwc#hwc)
