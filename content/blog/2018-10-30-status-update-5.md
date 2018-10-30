+++
date = "2018-10-30T00:00:00+02:00"
title = "Status update, october 2018"
slug = "status-update-5"
lang = "en"
tags = ["status update"]
+++

I kept my promise! Last month I said I'd try to publish a non-status-update
article, and [I did][wayland-rendering-loop]! I'm not used to writing articles
yet, so it takes quite some time, but I'll do my best to improve. Let me know if
you have specific article ideas in mind you'd be interested in.

This month we've published [sway 1.0-beta.1], and we've mostly focused on bug
fixes. For instance, I've finally figured out why transparency was broken on
Xwayland (this is a one year-old bug, [full story][xwayland-transparency]). I've
also fixed multi-GPU support by [setting it up on my laptop][mgpu-setup].

Apart from bug fixes, I've worked on a few new features too. `swayidle`, the
daemon responsible for taking actions when the compositor enters idle state, is
now able to enter immediately idle state. To do so, you just need to send the
`SIGUSR1` signal. This allows for instance to turn off screens when locking the
session ([example config][swayidle-config]).

The Wayland `presentation-time` protocol has also been implemented in sway. I've
been discussing with mpv folks to use it to improve playback.

Finally, I've started work for what I call Xcursor configuration. You might have
noticed that cursor sizes across Wayland apps are not consistent: GTK+ and sway
use a 24px cursor while Qt, Weston and GLFW use a 32px one. It's also not
possible to change the cursor theme, the default cursor, or to use different
settings for each seat. To fix this, I've been discussing with people from
GNOME, Qt and Wayland to build a solution. The idea would be to design a new
protocol and implement it in `libwayland-cursor` so that everybody can use it
without any major changes. All of this is still
[work-in-progress][wlroots-xcursor-configuration].

I have some mrsh news too! First, we have a new cool domain name: [mrsh.sh]. New
builtins have been added by [delthas] and readline/libedit support has been
implemented by [sircmpwn]. The latter is optional and enables a much friendlier
user interface. You can now use arrow keys to edit the current command or
navigate in the history! I've worked on arithmetic expressions, the groundwork
for the parser has been done but it still needs some more love.

Speaking of new websites, I actually have one additional new website:
[wayland.emersion.fr]. A list of the Wayland tools I'm maintaining is there. I
might expand this website with more Wayland development content, such as testing
tools and blog articles.

The [mako] notification daemon has received some updates thanks to great
contributors. Criteria has been improved to be more flexible, it should now be
possible to override size, margins and actions. Notification body parsing has
been fixed for clients that don't support markup (ie. HTML-like formatting).
Directional padding and showing notifications on the top or bottom center of the
screen are now supported. Thanks to the elogind people we now support
non-systemd systems.

That's all I have for today! In the next month I'll try to continue working on
improving laptop dock and multi-GPU support in wlroots, fixing issues with
arithmetic expressions in mrsh. Maybe I'll have a go at implementing job
control, if I understand which black magic incantations I should use (help
welcome if you know about this!). I'll definitely try to publish another
technical article, I need to get better at this. Thanks for reading!

[wayland-rendering-loop]: https://emersion.fr/blog/2018/wayland-rendering-loop/
[sway 1.0-beta.1]: https://github.com/swaywm/sway/releases/tag/1.0-beta.1
[xwayland-transparency]: https://github.com/swaywm/wlroots/issues/348
[mgpu-setup]: https://octodon.social/@emersion/100980595793850055
[swayidle-config]: https://git.sr.ht/%7Eemersion/dotfiles/tree/0e2472fea6f560f7fb788183ac668f29e4dfecf4/.config/sway/config#L137
[wlroots-xcursor-configuration]: https://github.com/swaywm/wlroots/pull/1324
[mrsh.sh]: https://mrsh.sh
[delthas]: https://delthas.fr/
[sircmpwn]: https://drewdevault.com/
[wayland.emersion.fr]: https://wayland.emersion.fr/
[mako]: https://wayland.emersion.fr/mako
