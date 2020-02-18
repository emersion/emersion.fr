+++
date = "2020-02-17T00:00:00+02:00"
title = "Status update, February 2020"
slug = "status-update-15"
lang = "en"
tags = ["status update"]
+++

The main event this month has been FOSDEM. This year's edition has been great,
I really enjoy meeting with folks I've been working with on various projects!
I've seen folks from Sway/wlroots, SourceHut, KDE, kernel drivers, and many
other projects.

I've also given a [talk about libliftoff][fosdem-talk]. First I've explained
what DRM planes are, hopefully so that people not extremely familiar with Linux
graphics can still understand it. Then I've presented the libliftoff project
and its current status. Last, the next steps and future plans are laid out.

I've made a lot of progress on the [koushin] front. I've added a CardDAV and a
CalDAV plugin, both are pretty basic right now but can easily be improved.
Support for HTML e-mails has been merged, sandboxed `<iframe>` elements and
`Content-Security-Policy` are used to further lock them down. The SourceHut
theme has been updated to integrate the latest features from existing plugins.
Drafts are now fully supported, although some more performance optimizations
are planned (the `CATENATE` extension would prevent koushin from having to
download and re-upload all attachments when updating a draft). A new API to
store user settings has been added, it uses the IMAP METADATA extension under
the hood to follow the near-zero-configuration koushin idiom. One the whole, I
think the plugin architecture turned out pretty well.

I've worked a lot on [go-webdav] as well. Both the client-side and server-side
of WebDAV and CardDAV are finished, CalDAV support is underway. A small WebDAV
server program is now included and allows one to quickly serve files from a
local directory. [hydroxide] now uses the new CardDAV server API. The main
missing feature is locking support, I'll try to spend some time designing a
nice API (I don't want this feature to be annoying to use).

I've spent some time writing a new Go library for dealing with PGP-encrypted
e-mails: [go-pgpmail]. For now it only supports PGP/MIME, but it can already
decrypt, verify, sign and encrypt messages. I plan to add support for reading
inline PGP e-mails, but not for writing them. This library will be useful when
adding support for PGP to aerc and koushin (signature verification only for the
latter of course).

I've started a new project this month to replace the IRC bouncer I'm currently
using, [znc]. I'd like to make it easier for users to join an existing IRC
bouncer and try to make IRC more user-friendly in general. Among other things,
I want to have better support for multiple clients (e.g. laptop + phone). I'd
also like to experiment with some sort of connection multiplexing: allow a
single connection to the bouncer to expose multiple upstream servers. Maybe an
IRC extension would be better suited for this, we'll see. Anyway, [jounce] is
now able to relay messages to a client and replay history. A whole lot of
features are missing: authentication, server configuration, TLS, database,
logs, and many other things. More on this next month!

As always, progress on [mrsh] has been slow but steady. Drew DeVault overhauled
the POSIX conformance test suite, uncovering some mrsh bugs in the process.
Apart from this, focus has been bug-fixing and cleaning up the API. We'll get
there eventually.

That's all, see you next month!

[fosdem-talk]: https://fosdem.org/2020/schedule/event/kms_planes/
[koushin]: https://git.sr.ht/~emersion/koushin
[go-webdav]: https://github.com/emersion/go-webdav
[hydroxide]: https://github.com/emersion/hydroxide
[go-pgpmail]: https://github.com/emersion/go-pgpmail
[znc]: https://znc.in/
[jounce]: https://git.sr.ht/~emersion/jounce
[mrsh]: https://mrsh.sh/
