# Splunk Distribution of OpenTelemetry Ruby

<p align="left">
  <a href="https://github.com/signalfx/gdi-specification/releases/tag/v1.2.0">
    <img alt="Splunk GDI specification" src="https://img.shields.io/badge/GDI-1.2.0-blueviolet?style=for-the-badge">
  </a>
  <a href="https://github.com/signalfx/splunk-otel-ruby/actions?query=workflow%3A%22Ruby+CI%22">
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

## Advanced configuration

See [advanced-config.md](docs/advanced-config.md) for information
on how to configure the instrumentation. Special instrumentation cases
are documented in [instrumentation-special-cases.md](instrumentation-special-cases.md).

# License


The Splunk OpenTelemetry Ruby distribution is released under the terms of the
Apache Software License version 2.0. For more details, see [the license
file](./LICENSE).

> Copyright 2021 Splunk Inc.
>
> Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
>
> http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
