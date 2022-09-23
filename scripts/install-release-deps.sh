#!/usr/bin/env bash

set -e

# instructions from https://github.com/cli/cli/blob/trunk/docs/install_linux.md#debian-ubuntu-linux-apt
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

apt-get update
apt-get -y install \
  ca-certificates="20211016~20.04.1" \
  curl="7.68.0-1ubuntu2.13" \
  gnupg="2.2.19-3ubuntu2.2" \
  lsb-release="11.1.0ubuntu2" \
  gh="2.16.0"
