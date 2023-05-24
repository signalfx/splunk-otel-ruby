#!/usr/bin/env bash

set -e

# ensure certs, curl and gpg are available before running them to setup the github repo
apt-get update
apt-get -y install \
  ca-certificates="20210119" \
  curl="7.74.0-1.3+deb11u3" \
  gnupg="2.2.27-2+deb11u2" \
  lsb-release="11.1.0" \

# instructions from https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-apt
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

apt-get update
apt-get -y install gh
