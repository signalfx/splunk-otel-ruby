# frozen_string_literal: true

require 'rails'

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/instrumentation/rack"
require "splunk/otel"
require "splunk/otel/instrumentation/rack"
require "rack/test"
require 'test_helpers/app_config.rb'

module Splunk
  class RumRailsTest < Test::Unit::TestCase
    include Rack::Test::Methods

    DEFAULT_RAILS_APP = AppConfig.initialize_app
    ::Rails.application = DEFAULT_RAILS_APP

    def setup
      with_env("OTEL_SERVICE_NAME" => "test-service") do
        Splunk::Otel.configure do |c|
            c.use 'OpenTelemetry::Instrumentation::ActionPack'
        end
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    def app
      DEFAULT_RAILS_APP
    end

    test "RUM response from Rack middleware" do
      get "/ok"

      assert last_response.ok?
      assert_equal "OK", last_response.body

      response_headers = last_response.headers
      assert_equal "Server-Timing", response_headers["Access-Control-Expose-Headers"]
      assert_match(/traceparent;desc="00-\w{32}-\w{16}-01"/, response_headers["Server-Timing"])
    end
  end
end
