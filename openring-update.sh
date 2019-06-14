#!/bin/sh -eu

export GO111MODULE=on

mkdir -p data
go run openring.go >data/openring.toml \
	-s "https://drewdevault.com/feed.xml" \
	-s "https://ppaalanen.blogspot.com/feeds/posts/default?alt=rss" \
	-s "http://blog.ffwll.ch/feed.xml" \
	-s "https://www.fooishbar.org/index.xml" \
	-s "https://idea.popcount.org/rss.xml" \
	-s "https://mstoeckl.com/notes/gsoc/rss.xml" \
	-s "http://research.swtch.com/feed.atom" \
	-s "https://ewontfix.com/feed.rss"
