#!/bin/sh -eux

# Extract the subset of Nanum Gothic Coding font we use
#
# Depends on python-fonttools

src_dir=node_modules/nanum-gothic-coding/fonts
basename=NanumGothicCoding-Bold
unicode_range="U+C2DC,U+BABD" # 시, 몽
for format in woff2 woff; do
	pyftsubset "$src_dir/$basename.woff2" --output-file="font/$basename.$format" --flavor=$format --layout-features='*' --unicodes="$unicode_range" &
done

wait
