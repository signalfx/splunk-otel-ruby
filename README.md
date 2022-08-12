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

- Ruby 2.6+

## Get started

This Splunk distribution comes with the following defaults:

- [W3C tracecontext](https://www.w3.org/TR/trace-context/) and [W3C
  baggage](https://www.w3.org/TR/baggage/) context propagation.
- OTLP over HTTP exporter configured to send spans to a locally running [Splunk
  OpenTelemetry Connector](https://github.com/signalfx/splunk-otel-collector)
  at http://localhost:4318.
- Unlimited default limits for configuration options to support full-fidelity
  traces.

Install the gem by adding it to your project's `Gemfile`:

``` ruby
gem "splunk-otel", "~> 0.1"
```

or

```shell
bundle add splunk-otel --version "~> 0.1"
```

Configure OpenTelemetry using the `Splunk::Otel` module from `splunk/otel`:

``` ruby
require "splunk/otel"
...
Splunk::Otel.configure
```

## Basic configuration

The `service.name` resource attribute is the only configuration option that
needs to be specified, using either the environment variable `OTEL_SERVICE_NAME`
or passing as an argument to `configure`:

``` ruby
Splunk::Otel.configure(service_name: "my-service")
```

Other resource attributes are not strictly required, but
`deployment.environment` and `service.version` are recommended to be set if they
are available. These can be set through the environment variable
`OTEL_RESOURCE_ATTRIBUTES`:

```
OTEL_RESOURCE_ATTRIBUTES="service.version=1.2.3,deployment.environment=production"
```

alternatively, if needed, more attributes can be added in code using:

```ruby
Splunk::Otel.configure(service_name: "my-service") do |c|
  c.resource = OpenTelemetry::SDK::Resources::Resource.create(
    "key" => "value"
  )
end
```

## Advanced configuration

See [advanced-config.md](docs/advanced-config.md) for information on how to
configure the instrumentation.

## Correlate traces and logs

You can add trace metadata to logs using the OpenTelemetry trace API. Trace
metadata lets you explore logs in Splunk Observability Cloud.

See [Correlating traces and logs](docs/correlating-traces-and-logs.md) for more information.

## Library instrumentation

Supported libraries are listed
[here](https://github.com/open-telemetry/opentelemetry-ruby-contrib/tree/main/instrumentation).
The corresponding gems for the instrumentation libraries can be found under the
[opentelemetry-ruby](https://rubygems.org/profiles/opentelemetry-ruby) profile
on [rubygems.org](https://rubygems.org).

### Automatic instrumentation

You can enable automatic instrumentation of all libraries used in your project
that have corresponding [OpenTelemetry Ruby
gems](https://rubygems.org/profiles/opentelemetry-ruby) libraries by installing
the
[opentelemetry-instrumentation-all](https://rubygems.org/gems/opentelemetry-instrumentation-all)
gem in your Gemfile:

``` ruby
gem "opentelemetry-instrumentation-all", "~> 0.23"
```

Enable the instrumentations from the gem by passing `auto_instrument:true` to
the `configure` method of `Splunk::Otel`. For example:

``` ruby
require "splunk/otel"

Splunk::Otel.configure(auto_instrument: true)
```

The gem fetches all instrumentation libraries but only enables those that
instrument a dependency in your project. For example, it will fetch
`opentelemetry-instrumentation-rack` but only if the `rack` gem is included and
used in your project will the instrumentation be enabled.

`auto_instrument: true` also works if individual instrumentation libraries are
installed, like the `opentelemetry-instrumentation-sinatra` gem.

To set configuration of one or more instrumentation libraries a config hash
can be passed to `use_all`:

``` ruby
OpenTelemetry::SDK.configure do |c|
  config = {'OpenTelemetry::Instrumentation::Redis' => { opt: "value" }}
  c.use_all(config)
end
```

The option `enabled` can be used to disable individual instrumentation libraries
when using `opentelemetry-instrumentation-all`:

``` ruby
OpenTelemetry::SDK.configure do |c|
  config = {'OpenTelemetry::Instrumentation::Redis' => { enabled: false }}
  c.use_all(config)
end
```

To enable instrumentation libraries manually, see [Manual instrumentation](#manually-instrument-code).

### Manual instrumentation

Instrumentation gems can also be installed and enabled individually. This may be
preferred in order to control exactly which gems are fetched when building your project.

Install the instrumentation library by including it in
the project's `Gemfile`. For example, to install the
[Sinatra](https://rubygems.org/gems/opentelemetry-instrumentation-sinatra)
instrumentation:

```
gem "opentelemetry-instrumentation-sinatra", "~> 0.19"
```

In a block passed to `Splunk::Otel.configure` configure the SDK to use
each of the instrumentation libraries. In the case of the Sinatra instrumentation,
the block would look like the following example:

``` ruby
require "splunk/otel"

Splunk::Otel.configure do |c|
  c.use "OpenTelemetry::Instrumentation::Sinatra", { opt: "value" }
end
```

### Real User Monitoring

``` ruby
Splunk::Otel.configure do |c|
    c.use "OpenTelemetry::Instrumentation::Rack"
end

Rack::Builder.app do
    use OpenTelemetry::Instrumentation::Rack::Middlewares::TracerMiddleware
    use Splunk::Otel::Rack::RumMiddleware
    run ->(_env) { [200, { "content-type" => "text/plain" }, ["OK"]] }
end
```

``` ruby
Splunk::Otel.configure do |c|
    c.use "OpenTelemetry::Instrumentation::ActionPack"
    c.use "Splunk::Otel::Instrumentation::ActionPack"
end
```

## Troubleshooting

For troubleshooting information, see the [Troubleshooting](docs/troubleshooting.md) documentation.

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
