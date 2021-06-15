+++
date = "2021-06-15T00:00:00+02:00"
title = "Status update, June 2021"
slug = "status-update-30"
lang = "en"
tags = ["status update"]
+++

Hi all!

Contrary to my usual habits, my primary focus this month has been neither
Wayland nor graphics. Instead, Drew DeVault and myself have put some effort
into the [gamja] IRC web client.

The improvements are too numerous to list exhaustively, but the main changes
include a bunch of new commands, collapsing less important messages, better
mobile support, case-mapping support, and displaying user modes in channels.
gamja has been deployed on many networks this month, including
[Libera Chat][gamja-libera-chat] (still experimental),
[tilde.chat][gamja-tilde-chat] and [Ergo][gamja-ergo-chat].

On the [soju] bouncer side, support for the [`soju.im/bouncer-networks`][bouncer-networks]
extension and for [`CHATHISTORY TARGETS`][chathistory-targets] has been merged.
This means gamja now provides a much better integration with soju, with a UI to
manage the networks the bouncer is connected to. I've also written a small
[Weechat script] — when enabled, users only need to setup a single connection
to the bouncer, the script will take care of automatically adding the rest of
the connections for the other networks. Gregory Anders also added support for
forwarding global user modes and the message of the day, thanks!

Even if I've focused on IRC software, I still had some time to spare for
Wayland. A [surprisingly][wlr-2901] [high][wlr-2507] [number][wlr-2505]
[of pieces][wlr-2829] of the puzzle are coming together to complete the
[renderer v6] plan. The main missing piece is [using the new infrastructure][wlr-2903]
for the DRM backend's primary planes. I've also worked on implementing
[per-surface hints for linux-dmabuf][wlr-dmabuf-hints], which will allow
fullscreen clients to hit the zero-copy direct scan-out path more often.
I'll release a new wlroots version soon, to allow the KWinFT project to
[move forward with their new wlroots backend][kwinft-wlr].

As always, I've been doing a lot of reviews across a lot of projects. A focal
point has been the DRM leasing patches for VR. I hope we'll be able to merge
the [Wayland protocol extension][wl-drm-lease], the
[Vulkan extension][vk-drm-display], the [Xwayland][xwl-drm-lease] and
[wlroots][wlr-drm-lease] patches in the near future. Xaver Hugl and Simon Zeni
have been driving this effort. Another effort that sparked discussion is an
[email I've sent to linux-mm][linux-mm-query] about avoiding `SIGBUS` in
Wayland compositors. Linus Torvalds and Ming Lin replied with patches to
improve the situation, I'm hopeful for an upstream-able patch.

Last but not least, I've finally come around to adding
[FreeBSD CI to Wayland][wl-freebsd-ci]. This will hopefully unblock the
portability patches we have queued up.

That's all for this month, see you in August!

[gamja]: https://sr.ht/~emersion/gamja/
[soju]: https://soju.im
[gamja-libera-chat]: https://web.libera.chat/gamja/
[gamja-tilde-chat]: https://tilde.chat/gamja/
[gamja-ergo-chat]: https://ergo.chat/gamja/
[wayland-freebsd-ci]: https://gitlab.freedesktop.org/wayland/wayland/-/merge_requests/146
[bouncer-networks]: https://git.sr.ht/~emersion/soju/tree/master/item/doc/ext/bouncer-networks.md
[chathistory-targets]: https://github.com/ircv3/ircv3-specifications/pull/450
[Weechat script]: https://github.com/weechat/scripts/blob/master/python/soju.py
[renderer v6]: https://github.com/swaywm/wlroots/issues/1352
[wlr-2901]: https://github.com/swaywm/wlroots/pull/2901
[wlr-2507]: https://github.com/swaywm/wlroots/pull/2507
[wlr-2505]: https://github.com/swaywm/wlroots/pull/2505
[wlr-2829]: https://github.com/swaywm/wlroots/pull/2829
[wlr-2903]: https://github.com/swaywm/wlroots/pull/2903
[wlr-dmabuf-hints]: https://github.com/swaywm/wlroots/pull/1376
[kwinft-wlr]: https://gitlab.com/kwinft/kwinft/-/issues/137
[wl-drm-lease]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/67
[vk-drm-display]: https://github.com/KhronosGroup/Vulkan-Docs/pull/1529
[xwl-drm-lease]: https://gitlab.freedesktop.org/xorg/xserver/-/merge_requests/606
[wlr-drm-lease]: https://github.com/swaywm/wlroots/pull/2929
[linux-mm-query]: https://lore.kernel.org/linux-mm/vs1Us2sm4qmfvLOqNat0-r16GyfmWzqUzQ4KHbXJwEcjhzeoQ4sBTxx7QXDG9B6zk5AeT7FsNb3CSr94LaKy6Novh1fbbw8D_BBxYsbPLms=@emersion.fr/
[wl-freebsd-ci]: https://gitlab.freedesktop.org/wayland/wayland/-/merge_requests/146
