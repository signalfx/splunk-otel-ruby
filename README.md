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
setup of OpenTelemetry SDK for reporting distributed traces to Splunk
APM.

This distribution comes with the following defaults:

- [W3C tracecontext and baggage propagation](https://www.w3.org/TR/trace-context).
- [OTLP exporter](https://rubygems.org/gems/opentelemetry-exporter-otlp)
  configured to send spans to a locally running [OpenTelemetry
  Collector](https://github.com/open-telemetry/opentelemetry-collector) over
  HTTP (default endpoint: `localhost:4318`).
- Unlimited default limits for [configuration options](#trace-configuration) to
  support full-fidelity traces.

If you're using the SignalFx Tracing Library for Ruby and want to migrate to the Splunk Distribution of OpenTelemetry Ruby, see [Migrate from the SignalFx Tracing Library for Ruby](https://quickdraw.splunk.com/redirect/?product=Observability&version=current&location=ruby.migrate) in the official documentation.

## Requirements

This distribution requires Ruby version 3.0 or higher.

## Get started

For complete instructions on how to get started with the Splunk Distribution of OpenTelemetry Ruby, see [Instrument a Ruby application for Splunk Observability Cloud](https://quickdraw.splunk.com/redirect/?product=Observability&version=current&location=ruby.application) in the official documentation.

## Advanced configuration

See [Configure the Ruby agent for Splunk Observability Cloud](https://quickdraw.splunk.com/redirect/?product=Observability&version=current&location=ruby.configuration) in the official documentation.

## Correlate traces and logs

You can add trace metadata to logs using the OpenTelemetry trace API. Trace
metadata lets you explore logs in Splunk Observability Cloud.

See [Connect Ruby trace data with logs for Splunk Observability Cloud](https://quickdraw.splunk.com/redirect/?product=Observability&version=current&location=ruby.trace.logs) in the official documentation.

## Library instrumentation

Supported libraries are listed
[here](https://github.com/open-telemetry/opentelemetry-ruby-contrib/tree/main/instrumentation).
You can find the corresponding gems for the instrumentation libraries under the
[opentelemetry-ruby](https://rubygems.org/profiles/opentelemetry-ruby) profile
on [rubygems.org](https://rubygems.org).


## Manual instrumentation

See [Manually instrument Ruby applications for Splunk Observability Cloud](https://quickdraw.splunk.com/redirect/?product=Observability&version=current&location=ruby.manual.instrumentation) for instructions on how to manually instrument Ruby applications.

## Configure for use with Smart Agent

This distribution includes the `jaeger-thrift-splunk` exporter, which is preconfigured to send data to local instance of the [SignalFx Smart Agent](https://github.com/signalfx/signalfx-agent).

To use the `jaeger-thrift-splunk` exporter, set the`OTEL_TRACES_EXPORTER` environment variable to `jaeger-thrift-splunk`, or append the exporter to the existing values. For example,  `OTEL_TRACES_EXPORTER=otlp,jaeger-thrift-splunk`.

If the `SPLUNK_REALM` or the `OTEL_EXPORTER_JAEGER_ENDPOINT` environmental variables are set, the default endpoint is overwritten.

## Troubleshooting

For troubleshooting information, see the [Troubleshoot Ruby instrumentation for Splunk Observability Cloud](https://quickdraw.splunk.com/redirect/?product=Observability&version=current&location=ruby.troubleshooting) in the official documentation.

# License

The Splunk OpenTelemetry Ruby distribution is licensed under the terms of the
Apache Software License version 2.0. For more details, see [the license
file](./LICENSE).

> Copyright 2021 Splunk Inc.
>
> Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
>
> http://www.apache.org/licenses/LICENSE-2.0
>
> Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

