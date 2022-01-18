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

      span_limits = OpenTelemetry::SDK::Trace::SpanLimits.new(attribute_count_limit: 1024,
                                                              event_count_limit: 512,
                                                              link_count_limit: 1000,
                                                              event_attribute_count_limit: 256,
                                                              link_attribute_count_limit: 128)

      OpenTelemetry.tracer_provider.span_limits = span_limits
    end

    module_function :configure
    # def configure(tracer: nil,
    #               ingest_url: ENV['SIGNALFX_ENDPOINT_URL'] || ENV['SIGNALFX_INGEST_URL'] || 'http://localhost:9080/v1/trace',
    #               service_name: ENV['SIGNALFX_SERVICE_NAME'] || "signalfx-ruby-tracing",
    #               access_token: ENV['SIGNALFX_ACCESS_TOKEN'],
    #               auto_instrument: false,
    #               span_tags: {})
    #   @ingest_url = ingest_url
    #   @service_name = service_name
    #   @access_token = access_token

    #   span_tags = process_span_tags(span_tags)
    #   set_tracer(tracer: tracer, service_name: service_name, access_token: access_token,
    #              span_tags: span_tags) if @tracer.nil?

    #   if auto_instrument
    #     Register.available_libs.each_pair do |key, value|
    #       begin
    #         value.instrument
    #       rescue Exception => e
    #         logger.error { "failed to initialize instrumentation '#{key}': #{e.inspect}" }
    #         logger.error { e.backtrace }
    #       end
    #     end
    #   else
    #     yield self
    #   end

    #   Compat.apply
    # end
  end
end
