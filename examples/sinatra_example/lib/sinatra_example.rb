# frozen_string_literal: true

require_relative "sinatra_example/version"
require "sinatra"
require "splunk/otel"

module SinatraExample
  class Error < StandardError; end

  class App < Sinatra::Base
    set :bind, '0.0.0.0'

    #configure do
    #  ENV['OTEL_TRACES_EXPORTER'] ||= 'console'
    #  Splunk::Otel.configure do |c|
    #      c.use 'OpenTelemetry::Instrumentation::Sinatra'
    #  end
    #end

    get "/" do
      "Hello world!"
    end
  end
end
