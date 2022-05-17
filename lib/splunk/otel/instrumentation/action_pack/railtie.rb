# frozen_string_literal: true

module Splunk
  module Otel
    module Instrumentation
      module ActionPack
        # Install the Rack middleware for RUM responses
        class Railtie < ::Rails::Railtie
          # TODO: use an explicit ordering to be after the Otel middleware
          # instead of just adding it to the end of the list of middlewares
          config.before_initialize do |app|
            app.middleware.use(
              Splunk::Otel::Rack::RumMiddleware
            )
          end
        end
      end
    end
  end
end
