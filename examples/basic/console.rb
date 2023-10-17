#!/usr/bin/env ruby
# frozen_string_literal: true

require "bundler/inline"

gemfile do
  source "https://rubygems.org"

  gem "splunk-otel", path: "../../"
end

require "splunk/otel"
require "splunk/otel/logging"
require "net/http"
require "json"

# a basic example module showing configuration through the Splunk distro
# and creating 2 spans and logs with trace correlation data
module BasicExample
  def some_spans
    logger = Logger.new($stdout)
    logger.level = Logger::INFO

    logger.formatter = proc do |_severity, _datetime, _progname, msg|
      "#{Splunk::Otel::Logging.format_correlation} : #{msg}\n"
    end

    Splunk::Otel.configure
    tracer = OpenTelemetry.tracer_provider.tracer("mytracer")
    tracer.in_span("basic-example-span-1") do |_span|
      tracer.in_span("basic-example-span-2") do |_span|
        logger.info("show log correlation")
      end
    end
  end

  def test
    collector_host = ENV.fetch("COLLECTOR_HOST", "localhost")
    collector_port = ENV.fetch("COLLECTOR_PORT", "8378").to_i

    BasicExample.some_spans

    response = Net::HTTP.get(collector_host, "/?timeout=20&count=1", collector_port)
    spans = JSON.parse(response)

    if spans.any? { |span| span["operationName"].to_s == "basic-example-span-1" }
      exit 0
    else
      exit 1
    end
  end

  module_function :some_spans, :test
end

if ENV.key?("TEST")
  BasicExample.test
else
  require "irb"
  IRB.start(__FILE__)
end
