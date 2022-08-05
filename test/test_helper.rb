# frozen_string_literal: true

require "simplecov"
SimpleCov.start

require "simplecov-cobertura"
SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "splunk/otel"

require "test-unit"

EXPORTER = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new

def with_env(new_env)
  env_to_reset = ENV.select { |k, _| new_env.key?(k) }
  keys_to_delete = new_env.keys - ENV.keys
  new_env.each_pair { |k, v| ENV[k] = v }
  yield
ensure
  env_to_reset.each_pair { |k, v| ENV[k] = v }
  keys_to_delete.each { |k| ENV.delete(k) }
end

def reset_opentelemetry
  EXPORTER.reset

  OpenTelemetry.instance_variable_set(
    :@tracer_provider,
    OpenTelemetry::Internal::ProxyTracerProvider.new
  )

  # OpenTelemetry will load the defaults
  # on the next call to any of these methods
  OpenTelemetry.error_handler = nil
  OpenTelemetry.propagation = nil
end
