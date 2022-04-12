# Advanced Configuration

## Correlating traces and logs

To add trace metadata of the current trace to logs, use the
`Splunk::Otel::Logging.format_correlation` function of the 
[Ruby standard logger](https://ruby-doc.org/stdlib-3.1.1/libdoc/logger/rdoc/Logger.html)
to set the formatter, as in the following example:

``` ruby
logger.formatter = proc do |severity, datetime, progname, msg|  
  "#{Splunk::Otel::Logging.format_correlation} #{msg}\n"
end

## Exporting directly to Splunk Observability Cloud

The OTLP trace exporter can export directly to Splunk Observability Cloud. To
achieve that, you need to set the `SPLUNK_ACCESS_TOKEN` and optional the
`SPLUNK_REALM` (defaults to `us0` if access token is set).

| Environment variable                   | Default value | Support     | Description                                                                                                                                          |
| -------------------------------------- | ------------  | ----------- | ---                                                                                                                                                  |
| `SPLUNK_ACCESS_TOKEN`                  | unset         | Stable      | (Optional) Auth token allowing exporters to communicate directly with the Splunk cloud, passed as `X-SF-TOKEN` header.                               |
| `SPLUNK_REALM`                         | unset         | Stable      | (Optional) A realm is a self-contained deployment that hosts organizations. You can find your realm name on your profile page in the user interface. |


## Propagators configuration

| Environment variable | Default value        | Support | Description                                                                                        |
| `OTEL_PROPAGATORS`     | `tracecontext,baggage` | Stable  | Comma-separated list of propagator names to be used. |

To keep backward compatibility with manual instrumentation for the SignalFx Ruby Tracing library, set the trace propagator to B3:

```
export OTEL_PROPAGATORS=b3multi
```
