+++
date = "2021-07-30T00:00:00+02:00"
title = "Setting up sr.ht for local development"
slug = "setting-up-sr.ht-for-local-development"
lang = "en"
tags = ["sr.ht"]
+++

I sometimes contribute to sr.ht. An important step in the contribution process
is to properly test the patches, even if they're a simple change. Getting a
good local development setup can be an intimidating task. I have a setup
which tries to minimize the amount of steps and indirections involved. This
post is a loose attempt at documenting it.

Disclaimer: this is not an official sr.ht resource, and this will likely become
out-of-date as sr.ht evolves. This article should be treated as a list of
hints, not as a complete tutorial. Some more advanced features like webhooks
are not covered.

See the [official documentation] for the canonical source of truth.

## Install dependencies

Follow your distribution's instructions to setup Postgres and Redis.

Using the [sr.ht package repositories] for your distribution will definitely
help, as all Python dependencies aren't always packaged. If you insist on not
using these repositories, most of the Python dependencies are in the AUR, but
sometimes are out-of-date or broken. Just try running the Python scripts and
install `python-<import name>` when you hit an import error.

## meta.sr.ht

meta.sr.ht is the base service that many other services depend on at least for
authentication. This it should be the first one to be set up.

Start by cloning the repository somewhere, together with core.sr.ht:

    cd ~/src
    git clone https://git.sr.ht/~sircmpwn/core.sr.ht
    git clone https://git.sr.ht/~sircmpwn/meta.sr.ht

Then configure `PYTHONPATH` to look up these directories, and set up
`SRHT_PATH`:

    export PYTHONPATH=$HOME/src/core.sr.ht:$HOME/src/meta.sr.ht
    export SRHT_PATH=$HOME/src/core.sr.ht/srht

Generate static assets and build the API:

    make
    cd api && go build

The next step is getting the configuration right for meta.sr.ht. Start with the
example config file (`mv config.example.ini config.ini`) then populate the
various fields. For the service-independent `[sr.ht]` section, the keys can be
generated with helpers found in core.sr.ht and the `redis-host` field should be
set to `redis://127.0.0.1`. The `[mail]` section doesn't need to be populated.

Then comes the `[meta.sr.ht]` section. To avoid the need to setup some hosts, I
like setting `origin=http://127.0.0.1:5000` (port same as `debug-port`).

To create and initialize the database:

    createdb meta.sr.ht
    ./metasrht-initdb

If you later update meta.sr.ht, run `./metasrht-migrate upgrade head` to run
database migrations.

Create a new admin user:

    ./metasrht-manageuser -t admin root

Once all that preparation work is done, meta.sr.ht should be ready to be
started:

    ./api/api
    python run.py

## todo.sr.ht

todo.sr.ht should be pretty simple to get running. Just like meta.sr.ht, clone
the repository, append it to `PYTHONPATH`, build static assets and the API.

The same configuration file should be used for all sr.ht services, so that all
can share the options from the common sections. So I just set up a symbolic
link:

    ln -s ../meta.sr.ht/config.ini config.ini

Take the todo.sr.ht specific blocks from `config.example.ini` and append them
to `config.ini`. As usual, populate the `origin` and `connection-string`
options. Since todo.sr.ht depends on meta.sr.ht for authentication, one extra
step is to generate some OAuth credentials in meta.sr.ht for todo.sr.ht (and
any other additional service you'll setup later on).

todo.sr.ht should now run just fine.

## git.sr.ht

Same as todo.sr.ht, but also needs scm.sr.ht to be added to `PYTHONPATH` (just
like core.sr.ht).

I like configuring `repos=./repos` and then setting up test repositories like
so:

    git init
    git remote add $HOME/src/git.sr.ht/repos/~root/test/

A `git push` should then show up in git.sr.ht's web UI.

## lists.sr.ht

This one is a bit more tricky, because it interacts with SMTP servers.

The setup isn't very different from other services. At the configuration phase,
the outgoing e-mail server needs to be configured in the `[mail]` section. I
use [go-smtp]'s debug server, which just dumps all traffic to stdout:

    git clone https://github.com/emersion/go-smtp.git
    cd go-smtp
    go run ./cmd/smtp-debug-server

Set `smtp-host=127.0.0.1` and `smtp-port=1025`, then you should be good to go.
Start the service as usual.

Incoming e-mail messages will be handled by two separate processes:

- A LMTP server will put the messages into a queue. Start the server with
  `./listssrht-lmtp`.
- A Celery worker will dequeue messages and dispatch them. Start the worker
  with `celery -A listssrht.process worker`.

Then submit messages to the LMTP server at `/tmp/lists.sr.ht-lmtp.sock`.

## Other services

Other services are very similar to the ones described so far. Some will need a
slightly different setup. The #sr.ht IRC channel is a good place to ask for
help if you're hitting a roadblock.

[official documentation]: https://man.sr.ht/installation.md
[sr.ht package repositories]: https://man.sr.ht/packages.md
[go-smtp]: https://github.com/emersion/go-smtp
