#!/usr/bin/env bash

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="${SCRIPT_DIR}/../"
cd "${ROOT_DIR}"

print_usage() {
  cat <<EOF
Usage: $(basename "$0") tag
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

create_gh_release() {
  echo ">>> Creating GitHub release $release_tag ..."
  gh release create "$release_tag" \
    --repo "signalfx/splunk-otel-ruby" \
    --draft \
    --title "Release $release_tag"
}

create_gh_release

bundle install
bundle exec rake build
bundle exec gem push pkg/splunk-otel-${release_version}.gem
