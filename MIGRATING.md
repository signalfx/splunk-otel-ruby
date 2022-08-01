# Migrate from the SignalFx Tracing Library for Ruby

The SignalFx Tracing Library for Ruby will soon be deprecated. Replace it with the
agent from the Splunk Distribution of OpenTelemetry Ruby.

The agent of the Splunk Distribution of OpenTelemetry Ruby is based on
the OpenTelemetry Instrumentation for Ruby, an open-source project that
uses the OpenTelemetry API.

Read the following instructions to learn how to migrate to the Splunk
Ruby OTel agent.

## Compatibility and requirements

The Splunk Distribution of OpenTelemetry Ruby requires Ruby 2.6 and
higher.

## Known limitations compared to SignalFx Tracing for Ruby

- Different subset of supported Ruby versions, see previous section
- No auto-instrumentation for
  (more details in
  [OTel instrumentation equivalents](#signalfx-instrumentations-equivalents)
  ):
    - `elasticsearch` (<https://github.com/elastic/elasticsearch-ruby>)
    - `grape` (<https://github.com/ruby-grape/grape>)
    - `sequel` (<https://github.com/jeremyevans/sequel>)

## Migrate to the Splunk Distribution of OpenTelemetry Ruby

To migrate from the SignalFx Tracing Library for Ruby to the Splunk
Distribution of OpenTelemetry Ruby, follow these steps:

1.  Remove the tracing library packages.
2.  Deploy the Splunk Distribution of OpenTelemetry Ruby.
3.  Migrate your existing configuration.

> Semantic conventions for span names and attributes change when you
migrate.

### Remove the SignalFx Tracing Library for Ruby

Follow these steps to remove the tracing library and its dependencies:

1.  Uninstall `signalfx`:

    ``` bash
    gem uninstall signalfx
    ```

1.  Remove `signalfx` from your Gemfile.

### Deploy the Splunk Ruby agent

To install the Splunk Distribution of OpenTelemetry Ruby, see the [README.md](README.md).

## Migrate to the Splunk Distribution of OpenTelemetry Ruby

We're currently only testing installation using Bundler with RubyGems as a source.
[Contact us](mailto:ssg-observability-instrumentals-ruby@splunk.com) if you require a different way of installation.

If you installed
[Smart Agent](https://github.com/signalfx/signalfx-agent)
to serve as a gateway (traces/metrics data proxy) then,
if possible, migrate to
[OpenTelemetry Collector](https://docs.splunk.com/Observability/gdi/opentelemetry/resources.html)
first.

### Deploy the Splunk Ruby agent

To install the Splunk Distribution of OpenTelemetry Ruby, see the [README.md](README.md).

### Replace SignalFx / OpenTracing gems with OTel equivalents

1.  Make a list of all `signalfx-*` instrumentation gems from your Gemfile, see
    [this table](https://github.com/signalfx/signalfx-ruby-tracing#supported-libraries)
    for a complete list.

1.  Replace them with Open Telemetry equivalents per the table below.

1.  Replace any other OpenTracing instrumentation packages you might have installed yourself.

<a name="signalfx-instrumentations-equivalents"></a>
#### OTel equivalents of SignalFx instrumentation gems

| SignalFx instrumentation name | OTel instrumentation name | notes |
| ----------------------------- | ------------------------- | ----- |
| signalfx-activerecord-opentracing | opentelemetry-instrumentation-active_record | |
| signalfx-elasticsearch-instrumentation | no known equivalents | [open issue in OTel](https://github.com/open-telemetry/opentelemetry-ruby-contrib/issues/8) |
| signalfx-faraday-instrumentation       | opentelemetry-instrumentation-faraday | |
| signalfx-grape-instrumentation         | no known equivalents | [open issue in OTel](https://github.com/open-telemetry/opentelemetry-ruby-contrib/issues/9) |
| signalfgx-mongodb-instrumentation      | opentelemetry-instrumentation-mongo | |
| signalfx-mysql2-instrumentation        | opentelemetry-instrumentation-mysql2 | |
| signalfx-nethttp-instrumentation       | opentelemetry-instrumentation-net_http | |
| signalfx-pg-instrumentation            | opentelemetry-instrumentation-pg | |
| signalfx-rack-tracer                   | opentelemetry-instrumentation-rack | |
| signalfx-rails-instrumentation         | opentelemetry-instrumentation-rails | |
| signalfx-redis-instrumentation         | opentelemetry-instrumentation-redis | |
| signalfx-restclient-instrumentation    | opentelemetry-instrumentation-restclient | |
| signalfx-sequel-instrumentation        | no known equivalents | [open issue in OTel](https://github.com/open-telemetry/opentelemetry-ruby-contrib/issues/11) |
| signalfx-sidekiq-opentracing           | opentelemetry-instrumentation-sidekiq | |
| signalfx-sinatra-instrumentation       | opentelemetry-instrumentation-sinatra | |

#### OTel equivalents of other Open Tracing instrumentation gems

See the list of all known OTel Ruby instrumentations: <https://opentelemetry.io/registry/?language=ruby&component=instrumentation>

### Migrate settings for the Splunk Ruby OTel agent

1. `SIGNALFX_ENDPOINT_URL` or `ingest_url` configuration parameter
    - if you installed Smart Agent and can migrate to OpenTelemetry Collector, do that first, then see the point below
    - if you have OpenTelemetry Collector available up as a sidecar (via `localhost`),
      and it accepts OTLP on default ports, then just remove this setting, we export OTLP to OTel Collector by default
    - if you need to keep using Smart Agent, then you need to set up a jaeger exporter yourself
    - if you export directly to our backend (without OTel Collector as a proxy),
      then just set `SPLUNK_REALM` to your realm

1. `SIGNALFX_SERVICE_NAME` or `service_name` configuration parameter
    - to set in environment use `OTEL_SERVICE_NAME`
    - to set in code use `Splunk::Otel.configure(service_name: 'your service name', ...`

1. `SIGNALFX_ACCESS_TOKEN` or `access_token` configuration parameter
    - can only be set in environment using `SPLUNK_ACCESS_TOKEN`

1. `SIGNALFX_SPAN_TAGS` or `span_tags`
    - TODO: check if we provide a way set resource

1. `SIGNALFX_RECORDED_VALUE_MAX_LENGTH`
    - can be set in environment using `OTEL_SPAN_ATTRIBUTE_VALUE_LENGTH_LIMIT`
    - see <https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#span-limits>

1. `tracer` configuration parameter
    - if you need to set its equivalent, open an issue, and tell us about your use case

For more information about Splunk Ruby OTel settings, see [advanced-config.md](docs/advanced-config.md).
