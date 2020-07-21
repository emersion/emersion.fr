+++
date = "2020-07-21T00:00:00+02:00"
title = "Status update, July 2020"
slug = "status-update-20"
lang = "en"
tags = ["status update"]
+++

Hi all! It's time for another monthly status update.

Yesterday I've [released] [wlroots 0.11.0] and [Sway 1.5]! This is a pretty big
release, with lots of new features and bug fixes. New features include headless
outputs that can be created on-the-fly (one use-case is remote VNC outputs).
Sway now supports the Wayland IME infrastructure, for instance
[almost][sway ime grab] allowing [C][wlchewing]J[K][wlhangul] input to work.
Adaptive synchronization (also known as Variable Refresh Rate) can be enabled
on a per-output basis. A bunch of new protocols are now supported: viewporter
for improved performance, keyboard-shortcuts-inhibit for better remoting and
virtualization client support, and wlr-foreign-toplevel for third-party docks &
window switchers. On top of all of these features, this release features a lot
of DRM fixes (less black screens!) and input-related fixes (especially for
touch and tablet devices). Resizing windows should also be more fluid.

In other Wayland news, a cool new feature has been added to [mako].
Markus Ongyerth has contributed [multi-surface support][mako multi-surface].
This allows to display groups of notifications in different locations on
screen. For instance one could now display regular notifications on the top
right corner and volume/brightness notifications in the middle of the screen.

I've started a new project, [gamja]. gamja is a web IRC client. It connects to
a WebSocket server and just uses the IRC protocol on the wire, so it doesn't
depend on a specific IRC server. gamja relies on some bleeding-edge IRCv3
extensions to provide extra functionality -- the user experience will be
improved if a server that supports them is used, for instance [soju].

![gamja screenshot](https://l.sr.ht/7Npm.png)

gamja supports basic operations you'd expect from an IRC client: joining
channels, sending messages, chatting privately with users, and so on. It also
features [chathistory] support: logs aren't stored on the device, instead they
are retrieved as needed. No more missing messages on connection loss!

My goal for gamja is to come up with a feature-rich and easy-to-use IRC client
that can compete with other messaging platforms while still integrating well
with the existing IRC ecosystem.

To wrap things up with yet a new project, let's talk about [tlsd]. For a while
I've been annoyed that it's only possible to get Let's Encrypt automatic TLS
for a web server. Other services (like a mail server or an IRC server) can't do
the same because only the webserver can listen to ports 80 and 443. Since I'd
really like to have zero-configuration TLS for these services as well, I'm
trying to come up with a solution. This proposal includes a daemon responsible
for retrieving TLS certificates and providing them to services running on the
machine. The daemon could be standalone (ala CertBot/Lego) or could be bundled
in the web server itself (ala Caddy). The key is to make the certificate
retrieval protocol standard so that certificate daemons and services can
inter-operate. I'm interested in feedback and ideas!

That's all I have, see you next month!

[released]: https://www.youtube.com/watch?v=keYXzDh5JEQ
[wlroots 0.11.0]: https://github.com/swaywm/wlroots/releases/tag/0.11.0
[Sway 1.5]: https://github.com/swaywm/sway/releases/tag/1.5
[mako]: https://wayland.emersion.fr/mako
[gamja]: https://sr.ht/~emersion/gamja/
[soju]: https://soju.im
[chathistory]: https://github.com/ircv3/ircv3-specifications/pull/393
[tlsd]: https://git.sr.ht/~emersion/tlsd
[mako multi-surface]: https://github.com/emersion/mako/pull/228
[sway ime grab]: https://github.com/swaywm/sway/pull/4932
[wlhangul]: https://github.com/emersion/wlhangul
[wlchewing]: https://github.com/xdavidwu/wlchewing
