# frozen_string_literal: true

require_relative "otel/version"

module Splunk
  # main module for application startup configuration
  module Otel
    # custom exception types in this gem must inherit from Splunk::Otel::Error
    # this allows the user to rescue a generic exception type to catch all exceptions
    class Error < StandardError; end

    def configure
      set_default_propagators
      set_default_exporter

      # run SDK's setup function
      OpenTelemetry::SDK.configure

      # set span limits to GDI defaults if not set by the user
      OpenTelemetry.tracer_provider.span_limits = gdi_span_limits

      verify_service_name
    end

    # verify `service.name` is set and print a warning if it is still the default
    def verify_service_name
      provider_resource = OpenTelemetry.tracer_provider.instance_variable_get(:@resource)
      resource_attributes = provider_resource.instance_variable_get(:@attributes)
      service_name = resource_attributes[OpenTelemetry::SemanticConventions::Resource::SERVICE_NAME]
      OpenTelemetry.logger.warn service_name_warning if service_name == "unknown_service"
    end

    def set_default_exporter
      default_env_vars({ "OTEL_EXPORTER_OTLP_TRACES_ENDPOINT" => "http://localhost:4318/v1/traces",
                         "OTEL_EXPORTER_OTLP_ENDPOINT" => "http://localhost:4318/v1/traces",
                         "OTEL_EXPORTER_OTLP_TRACES_COMPRESSION" => "gzip",
                         "OTEL_EXPORTER_OTLP_COMPRESSION" => "gzip",
                         "OTEL_TRACES_EXPORTER" => "otlp" })
    end

    def set_default_propagators
      default_env_vars({ "OTEL_PROPAGATORS" => "tracecontext,baggage" })
    end

    def gdi_span_limits
      default_env_vars({ "OTEL_SPAN_ATTRIBUTE_COUNT_LIMIT" => "1024",
                         "OTEL_RUBY_SPAN_ATTRIBUTE_VALUE_LENGTH_LIMIT" => "12000" })

      infinite_defaults = { "OTEL_SPAN_EVENT_COUNT_LIMIT" => :event_count_limit,
                            "OTEL_SPAN_LINK_COUNT_LIMIT" => :link_count_limit,
                            "OTEL_EVENT_ATTRIBUTE_COUNT_LIMIT" => :event_attribute_count_limit,
                            "OTEL_LINK_ATTRIBUTE_COUNT_LIMIT" => :link_attribute_count_limit }

      defaults = {}
      infinite_defaults.each do |k, v|
        defaults[v] = Float::INFINITY if ENV[k].nil?
      end

      OpenTelemetry::SDK::Trace::SpanLimits.new(**defaults)
    end

    # set environment varaible default's if the user hasn't set them
    def default_env_vars(env)
      env.each do |k, v|
        ENV[k] = v if ENV[k].nil?
      end
    end

    def service_name_warning
      <<~WARNING
        service.name attribute is not set, your service is unnamed and will be difficult to identify.
        set your service name using the OTEL_SERVICE_NAME environment variable.
        E.g. `OTEL_SERVICE_NAME="<YOUR_SERVICE_NAME_HERE>"`
      WARNING
    end

    module_function :configure, :gdi_span_limits, :set_default_propagators, :set_default_exporter,
                    :verify_service_name, :service_name_warning, :default_env_vars
  end
end
