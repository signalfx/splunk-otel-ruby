# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "splunk/otel"

module Splunk
  class CommonTest < Test::Unit::TestCase
    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service") do
        Splunk::Otel.configure
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "RUM server response headers" do
      tracer_provider = OpenTelemetry.tracer_provider
      tracer = tracer_provider.tracer("splunk-log-test", "1.0")

      tracer.in_span("log-span") do |span|
        trace_id = span.context.trace_id.unpack1("H*")
        span_id = span.context.span_id.unpack1("H*")

        headers = { "Access-Control-Expose-Headers" => "Server-Timing",
                    "Server-Timing" =>
                   "traceparent;desc=\"00-#{trace_id}-#{span_id}-01\"" }
        assert_equal(headers, Splunk::Otel::Common.rum_headers({}))
      end
    end
  end
end
