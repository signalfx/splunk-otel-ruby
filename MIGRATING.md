# Migrate from the SignalFx Tracing Library for Ruby

The SignalFx Tracing Library for Ruby is scheduled to be deprecated by the end of 2022.
Replace it with the Splunk Distribution of OpenTelemetry Ruby.

Splunk Distribution of OpenTelemetry Ruby is based on and compatible with
the OpenTelemetry Instrumentation for Ruby,
an open-source project that uses the OpenTelemetry API.

## Compatibility and requirements

The Splunk Distribution of OpenTelemetry Ruby requires Ruby 2.6 and
higher.

## Known limitations compared to SignalFx Tracing for Ruby

- Different subset of supported Ruby versions, see previous section
- Currently no auto-instrumentation for:
    - `elasticsearch` (<https://github.com/elastic/elasticsearch-ruby>)
    - `grape` (<https://github.com/ruby-grape/grape>)
    - `sequel` (<https://github.com/jeremyevans/sequel>)

More details in [OTel instrumentation equivalents](#signalfx-instrumentations-equivalents).

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

## Migrate to the Splunk Distribution of OpenTelemetry Ruby

We're currently only testing installation using Bundler with RubyGems as a source.
[Contact us](mailto:ssg-observability-instrumentals-ruby@splunk.com) if you require a different way of installation.

If you installed
[Smart Agent](https://github.com/signalfx/signalfx-agent)
to serve as a gateway (traces/metrics data proxy)
migrate to
[OpenTelemetry Collector](https://docs.splunk.com/Observability/gdi/opentelemetry/resources.html)
first, as soon as (if) possible.

### Deploy the Splunk Distribution of OpenTelemetry Ruby

To install the Splunk Distribution of OpenTelemetry Ruby, see the [README.md](README.md).

### Replace SignalFx / OpenTracing gems with OTel equivalents

1.  Make a list of all `signalfx-*` instrumentation gems from your Gemfile, see
    [this table](https://github.com/signalfx/signalfx-ruby-tracing#supported-libraries)
    for a complete list.

1.  Replace them with OpenTelemetry, as per the table below.

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

See the
[list of all known OTel Ruby instrumentations](https://opentelemetry.io/registry/?language=ruby&component=instrumentation)
in OpenTelemetry registry.

### Migrate settings for the Splunk Distribution of OpenTelemetry Ruby

1. `SIGNALFX_ENDPOINT_URL` or `ingest_url` configuration parameter
    - if you installed Smart Agent and can migrate to OpenTelemetry Collector, do that first, then see the point below
    - if you have OpenTelemetry Collector available up as a sidecar (via `localhost`),
      and it accepts OTLP on default ports, just remove this setting, we export OTLP to OTel Collector by default
    - if you need to keep using Smart Agent, you have to set up a jaeger exporter yourself
    - if you export directly to our backend (without OTel Collector as a proxy),
      just set `SPLUNK_REALM` to your realm
      (it's part of the URL, ie. `https://app.<realm>.signalfx.com/`, or `us0` if it's missing)

1. `SIGNALFX_SERVICE_NAME` or `service_name` configuration parameter
    - to set in environment, use `OTEL_SERVICE_NAME`
    - to set in code, use `Splunk::Otel.configure(service_name: 'your service name', ...`

1. `SIGNALFX_ACCESS_TOKEN` or `access_token` configuration parameter
    - to set in environment, use `SPLUNK_ACCESS_TOKEN`

1. `SIGNALFX_SPAN_TAGS` or `span_tags` configuration parameter
    - to set in environment:
        - first, you need to rewrite the existing value to the,
          which has a syntax of comma-separated `<key>=<value>` pairs (e.g. `key1=value1,key2=value2`)
        - set `OTEL_RESOURCE_ATTRIBUTES` to the new value
    - to set in code:
        - call `OpenTelemetry::SDK::Resources::Resource.create` with a `Hash`
          consisting of your existing key-value pairs
        - pass the newly created `Resource` to the `resource=` attribute in configuration
        - for example:
           ```ruby
           Splunk::Otel.configure(other_args) do |c|
             c.resource = OpenTelemetry::SDK::Resources::Resource.create(
               "key" => "value"
             )
             # ...
           end
           ```

1. `SIGNALFX_RECORDED_VALUE_MAX_LENGTH`
    - can be set in environment using `OTEL_SPAN_ATTRIBUTE_VALUE_LENGTH_LIMIT`
    - see
      [the list of span limits settings](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/sdk-environment-variables.md#span-limits)
      to learn more

1. `tracer` configuration parameter
    - if you need to set its equivalent, open an issue, and tell us about your use case

For more information about Splunk Ruby OTel settings, see [advanced-config.md](docs/advanced-config.md).
