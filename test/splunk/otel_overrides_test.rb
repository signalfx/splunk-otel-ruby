# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/propagator/b3"

module Splunk
  class OtelOverridesTest < Test::Unit::TestCase
    def setup
      ENV.clear
      with_env("OTEL_PROPAGATORS" => "b3multi",
               "SPLUNK_REALM" => "eu0",
               "SPLUNK_ACCESS_TOKEN" => "",
               "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT" => "",
               "OTEL_EXPORTER_OTLP_ENDPOINT" => "",
               "OTEL_RESOURCE_ATTRIBUTES" => "key1=value1,key2=value2") do
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
      assert_equal("https://ingest.eu0.signalfx.com/v2/trace/otlp", exporter.instance_variable_get(:@uri).to_s)

      # tests that setting SPLUNK_ACCESS_TOKEN to empty string does not set x-sf-token header
      assert_false(exporter.instance_variable_get(:@headers).to_s.downcase.include?("x-sf-token"))
    end
  end
end
