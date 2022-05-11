# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "splunk/otel"

module Splunk
  class LoggingTest < Test::Unit::TestCase
    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service",
               "SPLUNK_ACCESS_TOKEN" => "abcd") do
        Splunk::Otel.configure
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "log correlation" do
      # test against no active span
      assert_equal("service.name=test-service",
                   Splunk::Otel::Logging.format_correlation)

      tracer_provider = OpenTelemetry.tracer_provider
      tracer = tracer_provider.tracer("splunk-log-test", "1.0")

      tracer.in_span("log-span") do |span|
        trace_id = span.context.trace_id.unpack1("H*")
        span_id = span.context.span_id.unpack1("H*")
        assert_equal("service.name=test-service trace_id=#{trace_id} span_id=#{span_id}",
                     Splunk::Otel::Logging.format_correlation)
      end
    end
  end
end
