+++
date = "2020-04-17T00:00:00+02:00"
title = "Status update, April 2020"
slug = "status-update-17"
lang = "en"
tags = ["status update"]
+++

In the past month I've worked a lot on [soju], my IRC bouncer project. With the
help of delthas and Thorben Günther, soju is now ready for daily use! I've
switched to soju for almost all IRC networks I'm connected to. The blocker for
completely switching is detached channels, which I use quite extensively on
Freenode.

soju now handles all common IRC messages. It fully supports the multi-server
feature, which lets a user interact with multiple upstream servers from a
single connection to the bouncer. Basically, all channels for all networks will
appear with a "/&lt;network&gt;" suffix. I know this isn't the ideal solution,
but having to setup one connection per network is annoying (especially on
mobile devices). Also, I [have a plan][soju-namespace] to improve the status
quo (but it will require patching clients).

soju now also has an IRC service called _BouncerServ_. One can just send
commands to it. Commands include `net status` to check whether the bouncer is
connected to all configured networks and `net create` and `net delete` to
manage networks.

My next plans are to implement detaching channels to completely migrate to
soju. We still need to add support for some IRCv3 extensions like away-notify.
Some extensions can only be implemented if upstream servers support them,
I'm not sure yet how to handle these. If you're interested in contributing,
feel free to stop by on IRC or to have a look to the issue tracker!

I've also completed quite a few Wayland-related tasks this month. I've
continued work on explicit synchronization started last month, though I'm
hitting issues related to output cursors: the wlroots cursor API hasn't been
designed for this. I've started working on viewporter which will allow Xwayland
to make old games work better (using the full screen real estate rather than
letter-boxing the content). I've introduced `wlr_output_test` which allows
compositors to check whether an output configuration is valid before trying to
apply it. [wlr-randr] now has a `--dryrun` flag that uses this feature (via the
wlr-output-management protocol).

One last interesting feature I've been working on is adding support for virtual
outputs when using the DRM backend. This will allow virtual outputs to be
created on-the-fly in a regular Sway session. It'll be possible to use e.g.
[wayvnc] to remotely display the virtual output, a feature that for some reason
has been requested a lot lately.

I've also sent some Wayland protocol related patches. I've continued working on
[extending the linux-dmabuf protocol][dmabuf-hints] to give better buffer hints
for clients, allowing them to allocate more efficient buffers. I've submitted
the [layer-shell] and [KDE's idle protocol][idle-notify] for inclusion in
wayland-protocols.

My small-new-project-of-the-month is [sidediff]. It's a CLI tool to display a
side-by-side view of a diff. The answer to "why not just use `diff -y`?" is
that `diff` requires having the old and new files locally. I wanted a tool able
to work from just a diff file, for instance when reviewing patches sent by
e-mail.

There are a lot of other small things I'll only be able to mention: [koushin]
now has a new "alps" theme upstreamed ([sneak peak][alps]) and I've sent
patches [for][mesa-modifiers] [other][amdgpu-atomic-cursor]
[projects][mesa-pbo] [too][fish-pkgconfig]. But that's all for today! Take
care, see you next month!

[soju]: https://git.sr.ht/%7Eemersion/soju
[soju-namespace]: https://todo.sr.ht/~emersion/soju/16
[wlr-randr]: https://github.com/emersion/wlr-randr
[wayvnc]: https://github.com/any1/wayvnc
[dmabuf-hints]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/8
[layer-shell]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/28
[idle-notify]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/29
[sidediff]: https://git.sr.ht/~emersion/sidediff
[koushin]: https://git.sr.ht/~emersion/koushin
[alps]: https://l.sr.ht/0mOs.png
[fish-pkgconfig]: https://github.com/fish-shell/fish-shell/pull/6778
[mesa-modifiers]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/4298
[mesa-pbo]: https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/4422
[amdgpu-atomic-cursor]: https://lists.freedesktop.org/archives/amd-gfx/2020-March/047825.html
