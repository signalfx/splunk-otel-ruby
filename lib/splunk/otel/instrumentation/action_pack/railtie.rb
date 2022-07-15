# frozen_string_literal: true

require "rack/etag"

module Splunk
  module Otel
    module Instrumentation
      module ActionPack
        # Install the Rack middleware for RUM responses
        class Railtie < ::Rails::Railtie
          config.before_initialize do |app|
            case Rails.version
            when /^7\./
              # TODO: can be removed once https://github.com/rails/rails/issues/45607 is merged
              app.middleware.insert_before(
                ::Rack::ETag,
                Splunk::Otel::Rack::RumMiddleware
              )
            else
              app.middleware.use Splunk::Otel::Rack::RumMiddleware
            end
          end
        end
      end
    end
  end
end
