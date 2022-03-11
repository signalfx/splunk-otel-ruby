# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry-exporter-jaeger"

module Splunk
  class OtelProprietaryExportersTest < Test::Unit::TestCase
    def setup
      with_env("OTEL_TRACES_EXPORTER" => "jaeger-thrift-splunk") do
        Splunk::Otel.configure
      end
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    test "check that jaeger exporter is present" do
      processors = OpenTelemetry.tracer_provider.instance_variable_get("@span_processors")
      exporter = processors[0].instance_variable_get("@exporter")
      assert_instance_of OpenTelemetry::Exporter::Jaeger::CollectorExporter, exporter
    end
  end
end
