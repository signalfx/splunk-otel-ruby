# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/propagator/b3"

module Splunk
  class OtelOverridesTest < Test::Unit::TestCase
    def setup
      with_env("OTEL_PROPAGATORS" => "b3multi") do
        Splunk::Otel.configure
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "check propagators override of b3multi" do
      assert_equal(OpenTelemetry::Propagator::B3::Multi.text_map_propagator, OpenTelemetry.propagation)
    end
  end
end
