+++
date = "2020-11-23T00:00:00+02:00"
title = "Saying \"no\" to unethical tasks"
slug = "saying-no-to-unethical-tasks"
lang = "en"
tags = ["opinion"]
+++

Back in spring 2019, I was a student working as an intern at the Intel Open
Source Graphics Center in Finland. I was mainly focused on improving
[igt-gpu-tools], the test suite that runs each time a patch is submitted for
the i915 kernel driver. I really liked the work I was doing there, and enjoyed
interacting with all of the people on site. While I was there, I had an
opportunity to say "no" to an assigned task that I considered unethical.

Naturally, lots of Intel kernel developers were working on fixing bugs and
implementing new features. When a developer wants to add a new feature to their
kernel driver, they also need to provide a patch for a user-space program to
exercise the feature in a real-world scenario and prove that the new user-space
API is sensible[^1]. For instance, when adding HDR support to i915, the kernel
developers worked with the Kodi team.

At that time, I had just been nominated as release manager for the Wayland and
Weston projects. Additionally, some Intel engineers were working on upstreaming
Weston patches to add a new feature to their driver. In fact, the kernel
patches were ready to be merged and only blocked by the user-space
requirements. Some deadlines were set too, so it was important to get the
patches merged in a timely manner. My manager asked me to help with the
upstreaming process. That was a pretty good idea -- because my experience could
help Intel developers to learn how to contribute to Weston, and because I like
mentoring people. So what was the catch?

It turned out the feature being developed was [HDCP]. It's a form of <abbr
title="Digital Restrictions Management">DRM</abbr> that encrypts the video
stream between the GPU and the screen. I'm personally not okay with DRM in
general, and I find DRM to be unethical. I'm not going to start to argue why I
feel this way, because it doesn't really matter in the context of this article.
Feel free to replace DRM with whatever you find unethical.

So, I started participating to meetings and discussing how to get the
HDCP patches merged. I wasn't very comfortable with the whole situation, and
tried to stay away from it when possible. I considered saying "no", but I was
scared. I was only working at Intel for a few weeks, I was still a student, I
didn't know my teammates and managers too well, and I was interested in
eventually getting a job offer. I just continued as if nothing was wrong.

At some point, after asking advice and discussing with some friends, I realized
that I ought to speak up. If I didn't say "no" this time, it would get a lot
more difficult to say "no" the next time. So I ignored the anxiety and clumsily
explained to my manager that I'd like to stop working on HDCP.

To my surprise, my manager just said that it was fine, that there was no
problem. After this event, absolutely nothing else changed, and at some point I
even got an employment offer. When I recall it now, I can only tell myself that
it was a lot of fuss for nothing. In hindsight, I should've been less scared
and said no earlier, but in these situations it's easy to imagine nightmare
scenarios in your head!

[^1]: See [the kernel docs][drm-uapi-reqs] for more info.

[igt-gpu-tools]: https://gitlab.freedesktop.org/drm/igt-gpu-tools/
[drm-uapi-reqs]: https://dri.freedesktop.org/docs/drm/gpu/drm-uapi.html#open-source-userspace-requirements
[HDCP]: https://en.wikipedia.org/wiki/High-bandwidth_Digital_Content_Protection
