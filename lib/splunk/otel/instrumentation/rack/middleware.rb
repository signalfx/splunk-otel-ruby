# frozen_string_literal: true

require "splunk/otel/common"

module Splunk
  module Otel
    module Rack
      # RumMiddleware propagates context and instruments Rack responses
      # by way of its middleware system
      class RumMiddleware
        def initialize(app)
          @app = app
        end

        def call(env)
          status, headers, body = @app.call(env)

          headers = if Splunk::Otel.trace_response_header_enabled
                      Splunk::Otel::Common.rum_headers(headers)
                    else
                      headers
                    end

          [status, headers, body]
        end
      end
    end
  end
end
