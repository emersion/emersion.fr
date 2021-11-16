+++
date = "2021-11-16T00:00:00+02:00"
title = "Status update, November 2021"
slug = "status-update-35"
lang = "en"
tags = ["status update"]
+++

Hi again!

This month we've migrated wlroots to [FreeDesktop's GitLab instance][wlr-fdo]!
We've been preparing the migration for a long time, and finally all the pieces
of the puzzle came together.

The main missing piece was a way to keep our continuous integration system
working. We could've used GitLab CI, but we have some uncommon needs (FreeBSD,
loading kernel modules, etc) which would make things complicated. Instead we've
opted for another approach based on [dalligi], a custom GitLab CI runner which
forwards jobs to builds.sr.ht.

The migration went pretty well overall, GitLab's importer made the process
easy. As one would expect, _some_ things still went wrong and caused _some_
disruption. For instance, GitLab pull requests were imported as branches in the
new GitLab repository, so the original authors can't push to update them (they
need to re-open a new merge request). Some comments were randomly missing. Some
comments were imported with the wrong author because GitLab can't always link
the GitHub accounts. Last, CI wasn't running for new merge requests. It turns
out GitLab won't use the project's CI runners for merge requests, it'll only
use CI runners available to the author. We fixed that by asking a GitLab admin
to add dalligi as a global runner.

In other wlroots news, the new scene-graph API has been incrementally improved
with bug fixes and new features. It now supports direct scan-out, and I've been
working on adding [helpers for xdg-shell][scene-xdg-popup]. The
[cage patch][cage-scene] now removes a bit under 1k lines of code, ie. about
25% of the whole codebase.

I've also continued working on soju and gamja (the pieces of software behind
[chat.sr.ht]). soju now supports WHOX (allowing clients to query account
information), MONITOR and `extended-monitor` (allowing clients to provide
up-to-date user information in direct conversations). By the way,
`extended-monitor` is my first published IRCv3 extension! soju will soon be
able to use one separate IPv6 address for each bouncer user -- to avoid getting
the whole bouncer banned by an IRC network when a user misbehaves.

gamja as usual got a bunch of small quality-of-life upgrades. An optional
Parcel-based build system can be used to minimize and bundle the web app. gamja
can now open irc:// links when used with a bouncer, making it easier to jump
into a FOSS project's IRC channel.

Next month, I'll focus on getting the next wlroots release ready, ship a
chat.sr.ht upgrade with all of the soju + gamja improvements, and working on
some amdgpu bug fixes for Valve. See you!

[wlr-fdo]: https://gitlab.freedesktop.org/wlroots
[explicit-sync-v2]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/90
[dalligi]: https://git.sr.ht/~emersion/dalligi
[scene-xdg-popup]: https://gitlab.freedesktop.org/wlroots/wlroots/-/merge_requests/3298
[cage-scene]: https://github.com/Hjdskes/cage/pull/197
[chat.sr.ht]: https://man.sr.ht/chat.sr.ht/
