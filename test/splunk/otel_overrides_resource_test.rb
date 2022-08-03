# frozen_string_literal: true

require "test_helper"
require "opentelemetry/sdk"
require "opentelemetry/exporter/otlp"
require "opentelemetry/propagator/b3"

module Splunk
  class OtelOverridesResourceTest < Test::Unit::TestCase
    def subject
      @exporter = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
      span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(@exporter)

      # bust OTel's caching
      OpenTelemetry::SDK::Resources::Resource.instance_variable_set :@default, nil

      with_env("OTEL_RESOURCE_ATTRIBUTES" => "key1=value1,key2=value2") do
        Splunk::Otel.configure(service_name: "overrides-test") do |c|
          c.add_span_processor span_processor
          yield c if block_given?
        end
      end
    end

    def resource_attributes
      OpenTelemetry::SDK::Resources::Resource.instance_variable_set :@default, nil
      OpenTelemetry.tracer_provider.resource.attribute_enumerator.to_h
    end

    def teardown
      OpenTelemetry.tracer_provider.shutdown
    end

    def assert_distro_metadata
      assert_equal(resource_attributes["telemetry.sdk.name"], "opentelemetry")
      assert_equal(resource_attributes["telemetry.sdk.language"], "ruby")
    end

    def assert_process_metadata
      refute_nil resource_attributes["process.pid"]
      refute_nil resource_attributes["process.command"]
      assert_equal "ruby", resource_attributes["process.runtime.name"]
    end

    test "service name set through configuration argument" do
      subject

      assert_equal("overrides-test", resource_attributes["service.name"])
    end

    test "defaults are set" do
      subject
      assert_process_metadata
      assert_distro_metadata
    end

    test "resource can be set using ENV" do
      subject do |c|
        puts c.instance_variable_get(:@resource).attribute_enumerator.to_h
      end

      assert_equal("value1", resource_attributes["key1"])
      assert_equal("value2", resource_attributes["key2"])
      assert_process_metadata
      assert_distro_metadata
    end

    test "allows modifying resource in configuration" do
      subject do |c|
        c.resource = OpenTelemetry::SDK::Resources::Resource.create(
          "key3" => "value3"
        )
      end

      assert_equal("value3", resource_attributes["key3"])
      assert_equal("value1", resource_attributes["key1"])
      assert_equal("value2", resource_attributes["key2"])
      assert_process_metadata
      assert_distro_metadata
    end
  end
end
