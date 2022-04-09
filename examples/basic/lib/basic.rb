# frozen_string_literal: true

require_relative "basic/version"
require "splunk/otel"

# simple module with function creating a couple spans
module Basic
  class Error < StandardError; end
  # Your code goes here...

  def some_spans
    Splunk::Otel.configure

    tracer = OpenTelemetry.tracer_provider.tracer("span-1")
    tracer.in_span("search_by") do |span|

    end

    "expected"
  end

  module_function :some_spans
end
