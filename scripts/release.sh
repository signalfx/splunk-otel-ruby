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

# the gem publish for the tag is the most important so do that first
bundle install
bundle exec rake build
bundle exec gem push pkg/splunk-otel-${release_version}.gem
