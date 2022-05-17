# frozen_string_literal: true

module Splunk
  module Otel
    module Instrumentation
      # Contains the RUM instrumentation for the ActionPack gem
      module ActionPack
      end
    end
  end
end

require_relative "./action_pack/instrumentation"
require_relative "./action_pack/version"
