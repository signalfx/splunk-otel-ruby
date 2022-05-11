# frozen_string_literal: true

module Splunk
  module Otel
    # functions for shared functionality that will be used by multiple
    # instrumentation libraries. Like creating RUM headers used by any
    # HTTP library.
    module Common
      CORS_EXPOSE_HEADER = "Access-Control-Expose-Headers"
      SERVER_TIMING_HEADER = "Server-Timing"

      def rum_headers(headers)
        span = OpenTelemetry::Trace.current_span

        version = "00"
        trace_id = span.context.hex_trace_id
        span_id = span.context.hex_span_id
        flags = span.context.trace_flags.sampled? ? "01" : "00"

        trace_parent = [version, trace_id, span_id, flags]
        headers[SERVER_TIMING_HEADER] = "traceparent;desc=\"#{trace_parent.join("-")}\""

        # TODO: check if this needs to be conditioned on CORS
        headers[CORS_EXPOSE_HEADER] = if (headers[CORS_EXPOSE_HEADER] || "").empty?
                                        SERVER_TIMING_HEADER
                                      else
                                        "#{headers[CORS_EXPOSE_HEADER]}, #{SERVER_TIMING_HEADER}"
                                      end

        headers
      end

      module_function :rum_headers
    end
  end
end
