# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/rack"
require "splunk/otel"
require "splunk/otel/instrumentation/rack"
require "rack/test"

# test that the env var to disable RUM response headers works
module Splunk
  class RumDisabledRackTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service",
               "SPLUNK_TRACE_RESPONSE_HEADER_ENABLED" => "false") do
        span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(EXPORTER)
        Splunk::Otel.configure do |c|
          c.add_span_processor span_processor
          c.use "OpenTelemetry::Instrumentation::Rack"
        end
      end
    end

    def teardown
      reset_opentelemetry
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
      assert_nil response_headers["Access-Control-Expose-Headers"]
      assert_nil response_headers["Server-Timing"]

      # the middleware still starts and finishes a span
      assert_equal(1, EXPORTER.finished_spans.size)
    end
  end
end
