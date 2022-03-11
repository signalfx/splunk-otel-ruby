# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
Bundler.require(:default)

Splunk::Otel.configure do |configurator|
  $configurator = configurator # rubocop:disable Style/GlobalVars

  class << configurator
    def test_shutdown
      @span_processors.each(&:shutdown)
    end
  end
end

tracer = OpenTelemetry.tracer_provider.tracer("test", "1.0")
tracer.in_span("test-span") do
  puts "test-span execution"
end

$configurator.test_shutdown # rubocop:disable Style/GlobalVars
