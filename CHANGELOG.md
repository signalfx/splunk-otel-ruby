# Changelog

All notable changes to this repository are documented in this file.

The format is based on the [Splunk GDI specification](https://github.com/signalfx/gdi-specification/blob/v1.0.0/specification/repository.md),
and this repository adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

### Added

- OpenTelemetry Ruby SDK and API are updated to 1.0
- [pre-configured support for Smart
  Agent](https://github.com/signalfx/splunk-otel-ruby/pull/8)
- [support for SPLUNK_TRACE_RESPONSE_HEADER_ENABLED environment
  variable](https://github.com/signalfx/splunk-otel-ruby/pull/38)
  
## v0.1.0 - 2022-07-27

### Added

- [railtie based RUM Rack instrumentation](https://github.com/signalfx/splunk-otel-ruby/pull/26)
- [basic example using splunk distro](https://github.com/signalfx/splunk-otel-ruby/pull/20)
- [example of the most simplified rails setup](https://github.com/signalfx/splunk-otel-ruby/pull/24)
- [Rack RUM middleware](https://github.com/signalfx/splunk-otel-ruby/pull/23)
- [splunk.distro.version to resource attributes](https://github.com/signalfx/splunk-otel-ruby/pull/9)
- [MIGRATING.md docs for migrating from SignalFX Tracing Library](https://github.com/signalfx/splunk-otel-ruby/pull/18)
- [standard logging correlation formatter](https://github.com/signalfx/splunk-otel-ruby/pull/11)
- support `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM` environment variables for direct
  to Splunk exporting
