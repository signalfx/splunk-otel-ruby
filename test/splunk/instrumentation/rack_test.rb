# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/rack"
require "splunk/otel"
require "splunk/otel/instrumentation/rack"
require "rack/test"

module Splunk
  class RumRackTest < Test::Unit::TestCase
    include Rack::Test::Methods

    EXPORTER = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new

    def setup
      EXPORTER.reset

      with_env("OTEL_SERVICE_NAME" => "test-service") do
        span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(EXPORTER)
        Splunk::Otel.configure do |c|
          c.add_span_processor span_processor
          c.use "OpenTelemetry::Instrumentation::Rack"
        end
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    def app
      Rack::Builder.app do
        use OpenTelemetry::Instrumentation::Rack::Middlewares::TracerMiddleware
        use Splunk::Otel::Rack::RumMiddleware
        run ->(_env) { [200, { "content-type" => "text/plain" }, ["OK"]] }
      end
    end

    test "RUM response from Rack middleware" do
      get "/"

      assert last_response.ok?
      assert_equal "OK", last_response.body

      response_headers = last_response.headers
      assert_equal "Server-Timing", response_headers["Access-Control-Expose-Headers"]

      # the only started span is the one done by the Rack middleware
      # so the 1 span in the exporter is the one returned in the response
      assert_equal(1, EXPORTER.finished_spans.size)
      span = EXPORTER.finished_spans.first
      expected_trace_id = span.trace_id.unpack1("H*")
      expected_span_id = span.span_id.unpack1("H*")

      assert_match("traceparent;desc=\"00-#{expected_trace_id}-#{expected_span_id}-01\"",
                   response_headers["Server-Timing"])
    end
  end
end
