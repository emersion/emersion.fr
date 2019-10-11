#!/bin/sh

cd static
gpg --export 34FF9526CFEF0E97A340E2E40FDE7BE0E88F5E48 | openpgp-wkd-local add
