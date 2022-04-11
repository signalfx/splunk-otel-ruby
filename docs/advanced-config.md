# Advanced Configuration

## Logging

For adding the trace id and span id of the current trace to logs when using the
[Ruby standard
logger](https://ruby-doc.org/stdlib-3.1.1/libdoc/logger/rdoc/Logger.html) the
function `Splunk::Otel::Logging.format_correlation` is provided and can be used
to set the formatter:

``` ruby
logger.formatter = proc do |severity, datetime, progname, msg|  
  "#{Splunk::Otel::Logging.format_correlation} #{msg}\n"
end
```

This adds `service.name=<ServiceName> trace_id=<TraceId> span_id=<SpanId>` to
each log line.

## Exporting directly to Splunk Observability Cloud

The OTLP trace exporter can export directly to Splunk Observability Cloud. To
achieve that, you need to set the `SPLUNK_ACCESS_TOKEN` and optional the
`SPLUNK_REALM` (defaults to `us0` if access token is set).

| Environment variable                   | Default value | Support     | Description                                                                                                                                          |
| -------------------------------------- | ------------  | ----------- | ---                                                                                                                                                  |
| `SPLUNK_ACCESS_TOKEN`                  | unset         | Stable      | (Optional) Auth token allowing exporters to communicate directly with the Splunk cloud, passed as `X-SF-TOKEN` header.                               |
| `SPLUNK_REALM`                         | unset         | Stable      | (Optional) A realm is a self-contained deployment that hosts organizations. You can find your realm name on your profile page in the user interface. |


## Trace propagation configuration

| Environment variable | Default value        | Support | Description                                                                                        |
| `OTEL_PROPAGATORS`     | `tracecontext,baggage` | Stable  | Comma-separated list of propagator names to be used. |

If you wish to be compatible with SignalFx Ruby Tracing you can set the trace propagator to B3:

```
export OTEL_PROPAGATORS=b3multi
```
