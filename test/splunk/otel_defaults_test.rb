# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"

module Splunk
  class OtelDefaultsTest < Test::Unit::TestCase
    def setup
      ENV["OTEL_SERVICE_NAME"] = nil
      Splunk::Otel.configure
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "default service name different from otel default" do
      resource_attributes = OpenTelemetry.tracer_provider.resource.attribute_enumerator.to_h
      assert_equal("unnamed-ruby-service", resource_attributes["service.name"])
    end
  end
end
