# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/propagator/b3"

module Splunk
  class OtelOverridesTest < Test::Unit::TestCase
    def setup
      with_env("OTEL_PROPAGATORS" => "b3multi",
               "SPLUNK_REALM" => "eu0",
               "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT" => "",
               "OTEL_EXPORTER_OTLP_ENDPOINT" => "") do
        Splunk::Otel.configure(service_name: "overrides-test")
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "service name set through configuration argument" do
      resource_attributes = OpenTelemetry.tracer_provider.resource.attribute_enumerator.to_h
      assert_equal("overrides-test", resource_attributes["service.name"])
    end

    test "check propagators override of b3multi" do
      assert_equal(OpenTelemetry::Propagator::B3::Multi.text_map_propagator, OpenTelemetry.propagation)
    end

    test "check endpoint set to signalfx realm url" do
      processors = OpenTelemetry.tracer_provider.instance_variable_get(:@span_processors)

      batch_processor = processors[0]

      exporter = batch_processor.instance_variable_get(:@exporter)
      assert_equal("https://ingest.eu0.signalfx.com/v2/trace", exporter.instance_variable_get(:@uri).to_s)
    end
  end
end
