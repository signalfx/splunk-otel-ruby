# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"

module Splunk
  class OtelTest < Test::Unit::TestCase
    test "configure SDK and start trace" do
      Splunk::Otel.configure

      assert_equal([
                     OpenTelemetry::Trace::Propagation::TraceContext.text_map_propagator,
                     OpenTelemetry::Baggage::Propagation.text_map_propagator
                   ], OpenTelemetry.propagation.instance_variable_get(:@propagators))

      tracer = OpenTelemetry.tracer_provider.tracer("splunk-test", "1.0")

      tracer.in_span("span-1", attributes: { "attr.key.1" => "attr-value-1" }) do |span|
        span.set_attribute("attr.key.2", "attr-value-2")
      end
    end
  end
end
