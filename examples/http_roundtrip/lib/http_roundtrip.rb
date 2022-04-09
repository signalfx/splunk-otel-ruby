# frozen_string_literal: true

require_relative "http_roundtrip/version"
require "splunk/otel"
require "httpclient"
require "opentelemetry-instrumentation-http_client"

# example use of splunk otel distro with http client and server
module HttpRoundtrip
  class Error < StandardError; end

  def run
    e = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
    span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(e)

    Splunk::Otel.configure do |c|
      c.add_span_processor span_processor
    end

    tracer = OpenTelemetry.tracer_provider.tracer("mytracer")
    tracer.in_span("span-1") do |_span|
      http = HTTPClient.new
      r = http.get("http://example.com")
      r.body
    end

    e
  end

  module_function :run
end
