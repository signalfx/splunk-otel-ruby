# frozen_string_literal: true

module Splunk
  module Otel
    # functions for log correlation
    module Logging
      # return log formatted trace context
      def format_correlation
        resource_attributes = OpenTelemetry.tracer_provider.resource.attribute_enumerator.to_h
        service_name = resource_attributes["service.name"]
        span = OpenTelemetry::Trace.current_span

        if span == OpenTelemetry::Trace::Span::INVALID
          "service.name=#{service_name}"
        else
          %W[service.name=#{service_name} trace_id=#{span.context.hex_trace_id}
             span_id=#{span.context.hex_span_id}].join(" ")
        end
      end

      module_function :format_correlation
    end
  end
end
