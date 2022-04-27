# Correlating trace and logs

## Standard Ruby logger

To add trace metadata of the current trace to logs, use the
`Splunk::Otel::Logging.format_correlation` function of the 
[Ruby standard logger](https://ruby-doc.org/stdlib-3.1.1/libdoc/logger/rdoc/Logger.html)
to set the formatter, as in the following example:

``` ruby
require "splunk/otel"

logger.formatter = proc do |severity, datetime, progname, msg|  
  "#{Splunk::Otel::Logging.format_correlation} : #{msg}\n"
end
```

This adds `service.name=<ServiceName> trace_id=<TraceId> span_id=<SpanId>` to each log line.

```
service.name=basic-service trace_id=789b159aaee2b389a8771b2588278bcf
span_id=6d26eba14a81f3fa : show log correlation
```
