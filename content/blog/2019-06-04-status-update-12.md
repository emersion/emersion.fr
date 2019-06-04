+++
date = "2019-06-04T00:00:00+03:00"
title = "Status update, May 2019"
slug = "status-update-12"
lang = "en"
tags = ["status update"]
+++

This month is a little special: it's been one whole year I've started writing
status updates!

My list of projects has been growing, little by little, and I now spend a pretty
big slice of my "open-source contributions time" doing reviews. While this gives
me less time to code, it also allows these projects to grow way faster.
Unfortunately this also means I need to prioritize tasks -- for instance I
cannot reply to all bug reports (leaving it to the reporter or someone else to
investigate and send a patch). Of course, having regular contributors [helps a
lot][maintain-foss-projects] maintaining these projects!

This month I've released new versions of [slurp] and [grim]! You can now provide
a list of pre-defined regions to slurp, this enables quick selection of outputs
and windows (see the README examples). slurp now also supports selecting a
single pixel, so combined with grim and ImageMagick you can use it as a color
picker. grim can write PPM files, this is useful to speed it up when piping
images into another program. Big thanks to the contributors who added these
features!

I've also re-written [kanshi] in C. It was written in Rust previously, and this
has been an issue for this project[^1]. I want kanshi to be as low-maintenance
as possible, but since I'm not a Rust magician it takes time to add features and
fix bugs. Rust as a language is complicated, which makes it difficult for new
contributors to jump in and send patches. Last, a lot of bugs were due to the
Rust parser library used by kanshi, and I wanted to use the new
[output-management] protocol so some re-writing was needed anyway. kanshi is a
small utility, so thankfully re-writing it didn't take a long time.

I've contributed to [drm_info], a very nice utility written by ascent12 to print
information about your GPUs. I've added support for JSON output, which makes it
possible for a machine to interpret the output… And makes it possible to build a
database of GPUs: [drmdb]. drmdb is useful for Linux graphics developers when
they want to know whether a feature is widely supported, or what pixel formats
are available on a specific platform for instance. Please contribute by
uploading your GPUs' data!

I've volunteered to maintain the [go-mbox] package, updated the API to prevent
mutating messages, and made it so messages aren't stored in memory before being
read/written. I've also merged various patches for other my Go e-mail libraries
([go-imap], [go-maildir], [go-message] and friends). foxcpp has helped quite a
lot and is still actively adding new features to [maddy], thanks!

Last, I've started mentoring M. Stoeckl for his Google Summer of Code project:
Network transparency with Wayland. He already has made good progress with the
[waypipe] proxy. There are still lots of interesting details to fix and
optimize, but it's looking very promising!

That's all for this month! Thanks for reading!

[^1]: It doesn't mean Rust isn't a good fit for other projects!

[maintain-foss-projects]: https://drewdevault.com/2018/06/01/How-I-maintain-FOSS-projects.html
[slurp]: https://github.com/emersion/slurp
[grim]: https://github.com/emersion/grim
[drm_info]: https://github.com/ascent12/drm_info
[drmdb]: https://drmdb.emersion.fr
[kanshi]: https://github.com/emersion/kanshi
[go-mbox]: https://github.com/emersion/go-mbox
[go-maildir]: https://github.com/emersion/go-maildir
[go-message]: https://github.com/emersion/go-message
[waypipe]: https://gitlab.freedesktop.org/mstoeckl/waypipe/
[output-management]: https://github.com/swaywm/wlr-protocols/blob/master/unstable/wlr-output-management-unstable-v1.xml
