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

    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service") do
        Splunk::Otel.configure do |c|
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
      assert_match(/traceparent;desc="00-\w{32}-\w{16}-01"/, response_headers["Server-Timing"])
    end
  end
end
