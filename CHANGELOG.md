# Changelog

All notable changes to this repository are documented in this file.

The format is based on the [Splunk GDI specification](https://github.com/signalfx/gdi-specification/blob/v1.0.0/specification/repository.md),
and this repository adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## v1.1.3 - 2023-05-24

- No changes.

## v1.1.1 - 2023-05-24

- No significant changes.

## v1.1.0 - 2023-01-30

- fix handling of SPLUNK_ACCESS_TOKEN to check for empty string [#114](https://github.com/signalfx/splunk-otel-ruby/pull/114)

## v1.0.0 - 2022-09-29

## v0.3.0 - 2022-09-28

### Changed

- [Update opentelemetry-exporter-otlp requirement from ~> 0.21.0 to >= 0.21, <
  0.25](https://github.com/signalfx/splunk-otel-ruby/pull/60)
- [Update opentelemetry-propagator-b3 requirement from ~> 0.19.2 to >= 0.19.2, <
0.21.0](https://github.com/signalfx/splunk-otel-ruby/pull/35)
- [Update opentelemetry-exporter-jaeger requirement from ~> 0.20.1 to >= 0.20.1,
< 0 .23.0](https://github.com/signalfx/splunk-otel-ruby/pull/61)

## v0.2.0 - 2022-09-06

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
