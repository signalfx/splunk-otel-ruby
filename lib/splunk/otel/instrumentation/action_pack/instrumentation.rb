# frozen_string_literal: true

require "opentelemetry"
require "opentelemetry-instrumentation-base"

module Splunk
  module Otel
    module Instrumentation
      module ActionPack
        # The Instrumentation class contains logic to detect and install the ActionPack instrumentation
        class Instrumentation < OpenTelemetry::Instrumentation::Base
          MINIMUM_VERSION = Gem::Version.new("5.2.0")

          install do |_config|
            require_railtie
          end

          present do
            defined?(::ActionController)
          end

          compatible do
            gem_version >= MINIMUM_VERSION
          end

          option :enable_recognize_route, default: false, validate: :boolean

          private

          def gem_version
            ::ActionPack.version
          end

          def require_railtie
            require_relative "railtie"
          end
        end
      end
    end
  end
end
