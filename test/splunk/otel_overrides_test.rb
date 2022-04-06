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
        Splunk::Otel.configure
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "check propagators override of b3multi" do
      assert_equal(OpenTelemetry::Propagator::B3::Multi.text_map_propagator, OpenTelemetry.propagation)
    end

    test "check endpoint set to signalfx realm url" do
      processors = OpenTelemetry.tracer_provider.instance_variable_get(:@span_processors)

      batch_processor = processors[0]

      exporter = batch_processor.instance_variable_get(:@exporter)
      assert_equal("https://api.eu0.signalfx.com/v1/traces", exporter.instance_variable_get(:@uri).to_s)
    end
  end
end
