#!/usr/bin/env bash

set -e

# ensure certs, curl and gpg are available before running them to setup the github repo
apt-get update
apt-get -y install \
  ca-certificates="20210119" \
  curl="7.74.0-1.3+deb11u3" \
  gnupg="2.2.27-2+deb11u2" \
  lsb-release="11.1.0" \
