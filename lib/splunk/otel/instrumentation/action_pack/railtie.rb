# frozen_string_literal: true

require "rack/etag"

module Splunk
  module Otel
    module Instrumentation
      module ActionPack
        # Install the Rack middleware for RUM responses
        class Railtie < ::Rails::Railtie
          config.before_initialize do |app|
            app.middleware.insert_before(
              ::Rack::ETag,
              Splunk::Otel::Rack::RumMiddleware
            )
          end
        end
      end
    end
  end
end
