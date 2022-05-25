# frozen_string_literal: true

module Splunk
  module Otel
    module ActionPack
      # Install the Rack middleware for RUM responses
      class Railtie < ::Rails::Railtie
        config.before_initialize do |app|
          app.middleware.insert_before(
            0,
            Splunk::Otel::Rack::RumMiddleware
          )
        end
      end
    end
  end
end
