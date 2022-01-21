# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"

module Splunk
  class OtelTest < Test::Unit::TestCase
    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service") do
        Splunk::Otel.configure
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "configure SDK and start trace" do
      assert_equal([
                     OpenTelemetry::Trace::Propagation::TraceContext.text_map_propagator,
                     OpenTelemetry::Baggage::Propagation.text_map_propagator
                   ], OpenTelemetry.propagation.instance_variable_get(:@propagators))

      tracer_provider = OpenTelemetry.tracer_provider
      tracer = tracer_provider.tracer("splunk-test", "1.0")

      tracer.in_span("span-1", attributes: { "attr.key.1" => "attr-value-1" }) do |span|
        span.set_attribute("attr.key.2", "attr-value-2")
      end

      processors = OpenTelemetry.tracer_provider.instance_variable_get(:@span_processors)

      batch_processor = processors[0]
      assert_equal(512, batch_processor.instance_variable_get(:@batch_size))

      exporter = batch_processor.instance_variable_get(:@exporter)
      assert_equal("gzip", exporter.instance_variable_get(:@compression))
    end

    test "GDI defaults" do
      span_limits = OpenTelemetry.tracer_provider.instance_variable_get(:@span_limits)

      assert_equal(1024, span_limits.attribute_count_limit)
      assert_equal(12_000, span_limits.attribute_length_limit)
      assert_equal(Float::INFINITY, span_limits.event_count_limit)
      assert_equal(Float::INFINITY, span_limits.link_count_limit)
      assert_equal(Float::INFINITY, span_limits.event_attribute_count_limit)
      assert_equal(Float::INFINITY, span_limits.link_attribute_count_limit)
    end

    test "set service name" do
      provider_resource = OpenTelemetry.tracer_provider.instance_variable_get(:@resource)
      resource_attributes = provider_resource.instance_variable_get(:@attributes)
      assert_equal("test-service", resource_attributes["service.name"])
    end
  end
end
