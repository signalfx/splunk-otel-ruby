# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"

module Splunk
  class OtelTest < Test::Unit::TestCase
    test "configure SDK and start trace" do
      OpenTelemetry::SDK.configure

      tracer = OpenTelemetry.tracer_provider.tracer("splunk-test", "1.0")

      tracer.in_span("span-1", attributes: { "attr.key.1" => "attr-value-1" }) do |span|
        span.set_attribute("attr.key.2", "attr-value-2")
      end
    end
  end
end
