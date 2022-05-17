# frozen_string_literal: true

require "rails"

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/rack"
require "opentelemetry/instrumentation/action_pack"
require "splunk/otel"
require "splunk/otel/instrumentation/rack"
require "splunk/otel/instrumentation/action_pack"
require "splunk/otel/instrumentation/action_pack/railtie"
require "rack/test"
require "test_helpers/app_config"

module Splunk
  class RumRailsTest < Test::Unit::TestCase
    include Rack::Test::Methods

    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service") do
        Splunk::Otel.configure do |c|
          c.use "OpenTelemetry::Instrumentation::ActionPack"
          c.use "Splunk::Otel::Instrumentation::ActionPack"
        end
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    def app
      default_rails_app = AppConfig.initialize_app
      ::Rails.application = default_rails_app

      default_rails_app
    end

    test "RUM response from Rack middleware" do
      get "/ok"

      assert last_response.ok?
      assert_equal "OK", last_response.body

      response_headers = last_response.headers
      assert_equal "Server-Timing", response_headers["Access-Control-Expose-Headers"]
      assert_match(/traceparent;desc="00-\w{32}-\w{16}-00"/, response_headers["Server-Timing"])
    end
  end
end
