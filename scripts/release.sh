#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${SCRIPT_DIR}/../"
cd ${ROOT_DIR}

print_usage() {
  cat <<EOF
Usage: $(basename $0) tag"
Tag example: v1.2.3
EOF
}

if [[ $# != 1 ]]
then
  print_usage
  exit 1
fi

release_tag="$1"
# without the starting 'v'
release_version=$(echo "$release_tag" | cut -c2-)
# 1 from 1.2.3
major_version=$(echo "$release_version" | awk -F'.' '{print $1}')
minor_version=$(echo "$release_version" | awk -F'.' '{print $2}')
patch_version=$(echo "$release_version" | awk -F'.' '{print $3}')

setup_gpg() {
  echo ">>> Setting GnuPG configuration ..."
  mkdir -p ~/.gnupg
  chmod 700 ~/.gnupg
  cat > ~/.gnupg/gpg.conf <<EOF
no-tty
pinentry-mode loopback
EOF
}

import_gpg_secret_key() {
  local secret_key_contents="$1"

  echo ">>> Importing secret key ..."
  echo "$secret_key_contents" > seckey.gpg
  if (gpg --batch --allow-secret-key-import --import seckey.gpg)
  then
    rm seckey.gpg
  else
    rm seckey.gpg
    exit 1
  fi
}

create_gh_release() {
  echo ">>> Creating GitHub release $release_tag ..."
  gh release create "$release_tag" \
    --repo "signalfx/splunk-otel-ruby" \
    --draft \
    --title "Release $release_tag"
}

setup_git() {
  git config --global user.name release-bot
  git config --global user.email ssg-srv-gh-o11y-gdi@splunk.com
  git config --global gpg.program gpg
  git config --global user.signingKey "$GITHUB_BOT_GPG_KEY_ID"
}


create_gh_release

setup_gpg
import_gpg_secret_key "$GITHUB_BOT_GPG_KEY"
setup_git

# bundle exec rake release
