+++
date = "2021-07-21T00:00:00+02:00"
title = "Status update, July 2021"
slug = "status-update-31"
lang = "en"
tags = ["status update"]
+++

Hi! This status update comes a bit late, because I was on leave, biking in the
south of France for a few days.

This month I've released [mako 1.6], to try to make up for the long delay for
the last release. mako 1.6 brings quality-of-life improvements: modes allow
changing the configuration at runtime (and setting up e.g. a "Do Not Disturb"
mode), synchronous hints for easy usage in shell scripts, and the combo of the
new "exec" and "on-notify" bindings enable things like notification sound
alerts. These new features can be combined together to implement more creative
features, let me know if you find other good combos!

Continuing in the new release department, [libliftoff 0.1.0] is finally
out. It's been maturing for about 2 years now and it's used by default in
[gamescope]. The next step will be integrating it in wlroots.

I've been focused on wlroots bugfixes and stabilizing the recent renderer and
backend refactoring. wlroots 0.14.1 (also released this month) fixes a handful
of regressions. The huge renderer v6 internal refactoring is coming to an end
with the [last piece of the puzzle][wlroots-2903] almost ready.

In the wider Wayland ecosystem scene, I've spent some time reviewing the
numerous DRM leasing patches across wayland-protocols, Vulkan, Mesa, wlroots,
Xwayland and Monado. This work is necessary to complete support for Virtual
Reality headsets on Wayland. The Vulkan and Mesa bits have been merged, and the
wayland-protocols, wlroots and Xwayland patches are in good shape.

I've mentored [Joshua Ashton] and tricked him into getting into Wayland protocol
development. We've been working on a [surface-suspension] protocol to allow
off-screen surfaces to consume less resources, and at the same time fix buggy
Vulkan games. More work with Khronos will be required to move this forward.

The New Project Of The Month is [gh2srht], a small utility to migrate GitHub
issues to SourceHut. I've used it to migrate the kanshi issues. I'll be trying
to move more of my projects off of GitHub in the future, and use open-source
platforms such as SourceHut and FreeDesktop.Org's GitLab instance.

That's all for this month, see you in August!

[mako 1.6]: https://github.com/emersion/mako/releases/tag/v1.6
[libliftoff 0.1.0]: https://github.com/emersion/libliftoff/releases/tag/v0.1.0
[gamescope]: https://github.com/Plagman/gamescope
[wlroots-2903]: https://github.com/swaywm/wlroots/pull/2903
[Joshua Ashton]: https://blog.froggi.es/
[surface-suspension]: https://gitlab.freedesktop.org/wayland/wayland-protocols/-/merge_requests/99
[gh2srht]: https://git.sr.ht/~emersion/gh2srht
