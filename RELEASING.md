# Release Process

## Requirements

Releases to https://rubygems.org are done through Gitlab CI.

Scripts for performing the release can be found in `scripts/`. The scripts will
both create a draft Github Release and push a Gem.

## Steps

- Update `CHANGELOG.md`
- Bump version in `lib/splunk/otel/version.rb`
- Create PR
- Once PR is approved and merged created a tag with the same version as
  `version.rb` prefixed with `v` and push the tag
- Watch Gitlab CI for the `release` job to complete
- Update the newly created Github Release notes with the contents of
  `CHANGELOG.md`
