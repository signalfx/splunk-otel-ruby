require 'rubygems'
require 'bundler/setup'

Bundler.require
ENV['OTEL_TRACES_EXPORTER'] ||= 'console'
OpenTelemetry::SDK.configure do |c|
  c.use 'OpenTelemetry::Instrumentation::Sinatra'
end

require './lib/sinatra_example'
run SinatraExample::App
