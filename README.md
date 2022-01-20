# Splunk Distribution of OpenTelemetry Ruby

<p align="left">
  <a href="https://github.com/signalfx/gdi-specification/releases/tag/v1.2.0">
    <img alt="Splunk GDI specification" src="https://img.shields.io/badge/GDI-1.2.0-blueviolet?style=for-the-badge">
  </a>
  <a href="https://github.com/signalfx/splunk-otel-ruby/actions?query=workflow%3A%22CI+build%22">
    <img alt="Build Status" src="https://img.shields.io/github/workflow/status/signalfx/splunk-otel-ruby/Ruby%20CI?style=for-the-badge">
  </a>
</p>

The Splunk Distribution of [OpenTelemetry Instrumentation for
Ruby](https://github.com/open-telemetry/opentelemetry-ruby) provides a gem for
setup of OpenTelemetry SDK for reporting distributed traces to [Splunk
APM](https://docs.splunk.com/Observability/apm/intro-to-apm.html).

This distribution comes with the following defaults:

- [W3C tracecontext and baggage propagation](https://www.w3.org/TR/trace-context).
- [OTLP exporter](https://rubygems.org/gems/opentelemetry-exporter-otlp)
  configured to send spans to a locally running [OpenTelemetry
  Collector](https://github.com/open-telemetry/opentelemetry-collector) over
  HTTP (default endpoint: `localhost:4318`).
- Unlimited default limits for [configuration options](#trace-configuration) to
  support full-fidelity traces.

## Requirements

- Ruby 2.5+

## Get started

Add this gem to your project's `Gemfile` file:

``` ruby
gem "splunk-otel", "~> 0.1"
```


``` ruby
Splunk::Otel.configure
```

## Configure instrumentation for a Ruby application

## Using B3 Propagator

To switch to using the [B3](https://github.com/openzipkin/b3-propagation)
propagation format set `OTEL_PROPAGATORS` to `b3multi`:

```sh
export OTEL_PROPAGATORS=b3multi
```
