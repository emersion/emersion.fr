+++
date = "2020-03-17T00:00:00+02:00"
title = "Status update, March 2020"
slug = "status-update-16"
lang = "en"
tags = ["status update"]
+++

This month I've worked a lot on Wayland-related projects. The most user-facing
feature is probably Variable Refresh Rate (VRR), also called adaptive sync.
But what is VRR? Usually screens have a fixed refresh rate (e.g. 60Hz). Each
16.6ms the GPU sends a new image to the screen. This means applications need to
render at a strict interval, otherwise they miss the deadline and need to wait
a whole frame worth of time before being able to update the screen. VRR relaxes
these deadlines and allows the GPU to send frames to the screen a little bit
too late. This is great for gaming, because sometimes the game engine misses the
deadline by a bit. There are also power-saving and video playback use-cases, but
we aren't there yet.

However, because of some hardware limitations changing the refresh rate too
quickly can cause flickering. To workaround this issue, xf86-video-amdgpu uses
a special application blacklist and only enables VRR when fullscreen is used.
I'm not a fan of this approach, so I've started a discussion with amdgpu and
i915 developers to see if we could avoid flickering in the kernel driver.

If you want to try this feature out, add `output * adaptive_sync on` to your
Sway config and check it's enabled with `swaymsg -t get_outputs`. More details
are available in the [Sway pull request][sway adaptive_sync] and the [Sway
follow-up issue][sway automatic vrr]. I've also created a small [drm_monitor]
tool to get page-flip timings right out of the kernel.

I've also worked on behind-the-scenes improvements for wlroots. My goal is to
slowly and incrementally transition into the so-called "renderer v6 redesign".
We want to use GBM liberally to have more control over the rendering pipeline.
We want to make use of hardware planes (via [libliftoff]). Getting all the
pieces together is a lot of work though. This month I've worked on improving
our `wlr_buffer` interface. A [first step][wlroots wlr_client_buffer] splits
the client-related state into a separate struct, allowing compositors to
create their own `wlr_buffer`. A [second step][wlroots buffer-next] extends
`wlr_buffer` to make it possible to create our own swap-chains. I've also
started working on [explicit synchronization support][wlroots explicit sync].

In other Wayland news, [xdg-desktop-portal-wlr] has gained support for screen
capture! This allows wlroots to interoperate with e.g. Firefox and GNOME apps.
It's still pretty much experimental (for instance it needs to be restarted each
time a screen capture ends), but it works. Big thanks to Dan Shick for this
nice work!

A new project, [wlhangul], enables Hangul (the Korean writing system) input
method on Wayland. If you want to try it out, you'll need the [still
work-in-progress Sway patches][sway input-method]. I've been impressed how easy
it was to write this small 350 LOC client. Here's how it looks like:

<video src="https://assets.octodon.social/media_attachments/files/008/877/270/original/73c57c7312c63c75.mp4" controls></video>

I've made good progress on my IRC bouncer, previously known as jounce but
renamed to [soju]. It's now using a SQLite database to store users, networks
and channels. It has a multi-consumer ring buffer to store history so that only
unseen messages are sent to each client. To join a new IRC network, one can
just connect to the bouncer with the username `<username>@<address>`, for
instance `emersion@chat.freenode.net`. Registering or authenticating with
NickServ will save the credentials (SASL will be used when connecting).
Channels are automatically saved on join and part.

There's still a lot of work to do. A lot of IRC commands need to be
implemented plus some IRCv3 extensions. I'd like to implement a virtual IRC
user that accepts commands to manage the bouncer too (ala ZNC's `*status`).
Docs are also lacking at the moment.

One last thing I've been working on is [go-ical], a Go library for iCalendar.
The existing libraries were either too big or not suitable for serializing
iCal, so I had to write a new one. This'll be useful for [koushin]'s CalDAV
plugin.

See you next month!

[sway adaptive_sync]: https://github.com/swaywm/sway/pull/5063
[sway automatic vrr]: https://github.com/swaywm/sway/issues/5076
[drm_monitor]: https://github.com/emersion/drm_monitor
[libliftoff]: https://github.com/emersion/libliftoff
[wlroots wlr_client_buffer]: https://github.com/swaywm/wlroots/pull/2043
[wlroots buffer-next]: https://github.com/swaywm/wlroots/pull/2044
[wlroots explicit sync]: https://github.com/swaywm/wlroots/pull/2070
[xdg-desktop-portal-wlr]: https://github.com/emersion/xdg-desktop-portal-wlr
[wlhangul]: https://github.com/emersion/wlhangul
[sway input-method]: https://github.com/swaywm/sway/pull/4932
[soju]: https://git.sr.ht/~emersion/soju
[go-ical]: https://github.com/emersion/go-ical
[koushin]: https://git.sr.ht/~emersion/koushin
[xdg-shell popup repositioning]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/6/
