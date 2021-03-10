#!/bin/sh -eu

# Get these with:
# gpg --list-keys --with-wkd-hash
key_id=34FF9526CFEF0E97A340E2E40FDE7BE0E88F5E48
wkd_hash=dj3498u4hyyarh35rkjfnghbjxug6b19

gpg --export "$key_id" >static/.well-known/openpgpkey/hu/"$wkd_hash"
