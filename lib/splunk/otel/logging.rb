# frozen_string_literal: true

module Splunk
  module Otel
    # functions for log correlation
    module Logging
      # return log formatted trace context
      def format_correlation
        span = OpenTelemetry::Trace.current_span
        %W[trace_id=#{span.context.hex_trace_id} span_id=#{span.context.hex_span_id}].join(" ")
      end

      module_function :format_correlation
    end
  end
end
