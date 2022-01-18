# frozen_string_literal: true

require_relative "otel/version"

module Splunk
  # main module for application startup configuration
  module Otel
    # custom exception types in this gem must inherit from Splunk::Otel::Error
    # this allows the user to rescue a generic exception type to catch all exceptions
    class Error < StandardError; end

    def configure
      OpenTelemetry::SDK.configure do |c|
        exporter = OpenTelemetry::Exporter::OTLP::Exporter.new(endpoint: "http://localhost:4318", compression: "gzip")
        c.add_span_processor(OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new(exporter))
      end

      OpenTelemetry.tracer_provider.span_limits = gdi_span_limits
    end

    def gdi_span_limits
      OpenTelemetry::SDK::Trace::SpanLimits.new(attribute_count_limit: 1024,
                                                attribute_length_limit: 12_000,
                                                event_count_limit: Float::INFINITY,
                                                link_count_limit: Float::INFINITY,
                                                event_attribute_count_limit: Float::INFINITY,
                                                link_attribute_count_limit: Float::INFINITY)
    end

    module_function :configure, :gdi_span_limits
  end
end
