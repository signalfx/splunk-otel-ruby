# frozen_string_literal: true

require "opentelemetry/sdk"
require "opentelemetry-exporter-otlp"

require_relative "otel/version"
require_relative "otel/proprietary_exporters"

module Splunk
  # main module for application startup configuration
  module Otel # rubocop:disable Metrics/ModuleLength
    # custom exception types in this gem must inherit from Splunk::Otel::Error
    # this allows the user to rescue a generic exception type to catch all exceptions
    class Error < StandardError; end

    attr_reader(:trace_response_header_enabled)

    @trace_response_header_enabled = true

    # Configures the OpenTelemetry SDK and instrumentation with Splunk defaults.
    #
    # @yieldparam [Configurator] configurator Yields a configurator to the
    #   provided block
    #
    # Example usage:
    #   Without a block defaults are installed without any instrumentation
    #
    #     Splunk::Otel.configure
    #
    #   Install instrumentation individually with optional config
    #
    #     Splunk::Otel.configure do |c|
    #       c.use 'OpenTelemetry::Instrumentation::Faraday', tracer_middleware: SomeMiddleware
    #     end
    #
    #   Install all instrumentation with optional config
    #
    #     Splunk::Otel.configure do |c|
    #       c.use_all 'OpenTelemetry::Instrumentation::Faraday' => { tracer_middleware: SomeMiddleware }
    #     end
    #
    #   Add a span processor
    #
    #     Splunk::Otel.configure do |c|
    #       c.add_span_processor SpanProcessor.new(SomeExporter.new)
    #     end
    #
    #   Configure everything
    #
    #     Splunk::Otel.configure do |c|
    #       c.logger = Logger.new(File::NULL)
    #       c.add_span_processor SpanProcessor.new(SomeExporter.new)
    #       c.use_all
    #     end
    def configure(service_name: ENV.fetch("OTEL_SERVICE_NAME", "unnamed-ruby-service"),
                  auto_instrument: false,
                  trace_response_header_enabled: ENV.fetch("SPLUNK_TRACE_RESPONSE_HEADER_ENABLED", "true"))
      @trace_response_header_enabled = to_boolean(trace_response_header_enabled)

      set_defaults

      # run SDK's setup function
      OpenTelemetry::SDK.configure do |configurator|
        class << configurator
          include Splunk::Otel::ExporterExtensions
        end

        configurator.service_name = service_name
        configurator.resource = OpenTelemetry::SDK::Resources::Resource.create(
          "splunk.distro.version" => Splunk::Otel::VERSION
        )

        configurator.use_all if auto_instrument
        yield configurator if block_given?
      end

      # set span limits to GDI defaults if not set by the user
      OpenTelemetry.tracer_provider.span_limits = gdi_span_limits

      verify_service_name
    end

    def set_defaults
      set_default_propagators
      set_access_token_header
      set_default_exporter
      set_default_span_limits
    end

    # verify `service.name` is set and print a warning if it is still the default
    def verify_service_name
      provider_resource = OpenTelemetry.tracer_provider.instance_variable_get(:@resource)
      resource_attributes = provider_resource.instance_variable_get(:@attributes)
      service_name = resource_attributes[OpenTelemetry::SemanticConventions::Resource::SERVICE_NAME]
      OpenTelemetry.logger.warn service_name_warning if service_name == "unknown_service"
    end

    def set_default_exporter
      set_endpoint
      default_env_vars({ "OTEL_EXPORTER_OTLP_TRACES_COMPRESSION" => "gzip",
                         "OTEL_EXPORTER_OTLP_COMPRESSION" => "gzip",
                         "OTEL_TRACES_EXPORTER" => "otlp" })
    end

    def set_endpoint
      traces_endpoint = ENV.fetch("OTEL_EXPORTER_OTLP_TRACES_ENDPOINT", nil)
      endpoint = ENV.fetch("OTEL_EXPORTER_OTLP_ENDPOINT", nil)
      splunk_realm = ENV.fetch("SPLUNK_REALM", nil)

      # if user hasn't set traces endpoint or endpoint but has set the realm then
      # set the endpoints to be https://api.<SPLUNK_REALM>.signalfx.com
      # if either endpoint variable was set by the user then use those even if
      # they've also set SPLUNK_REALM
      return unless traces_endpoint.to_s.empty?
      return unless endpoint.to_s.empty?

      ENV["OTEL_EXPORTER_OTLP_TRACES_ENDPOINT"] = if splunk_realm.to_s.empty? || splunk_realm.to_s.eql?("none")
                                                    "http://localhost:4318/v1/traces"
                                                  else
                                                    "https://ingest.#{splunk_realm}.signalfx.com/v2/trace/otlp"
                                                  end
    end

    # add the access token header if the env variable is set
    def set_access_token_header
      splunk_access_token = ENV.fetch("SPLUNK_ACCESS_TOKEN", nil)
      return if splunk_access_token.nil?

      access_header = "x-sf-token=#{splunk_access_token}"
      headers = ENV.fetch("OTEL_EXPORTER_OTLP_HEADERS", nil)
      ENV["OTEL_EXPORTER_OTLP_HEADERS"] = if headers.to_s.empty?
                                            access_header
                                          else
                                            "#{headers},#{access_header}"
                                          end
    end

    def set_default_propagators
      default_env_vars({ "OTEL_PROPAGATORS" => "tracecontext,baggage" })
    end

    def set_default_span_limits
      default_env_vars({ "OTEL_SPAN_LINK_COUNT_LIMIT" => "1000",
                         "OTEL_RUBY_SPAN_ATTRIBUTE_VALUE_LENGTH_LIMIT" => "12000" })
    end

    def gdi_span_limits
      infinite_defaults = { "OTEL_SPAN_ATTRIBUTE_COUNT_LIMIT" => :attribute_count_limit,
                            "OTEL_SPAN_EVENT_COUNT_LIMIT" => :event_count_limit,
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

    def to_boolean(val)
      # val could already be a boolean so just return the value if it is already
      # true or false
      case val
      when true then true
      when false then false
      else
        !%w[false
            no
            f
            0].include?(val.strip.downcase)
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
                    :verify_service_name, :service_name_warning, :default_env_vars,
                    :set_default_span_limits, :set_access_token_header, :set_endpoint,
                    :to_boolean, :trace_response_header_enabled, :set_defaults
  end
end

require "splunk/otel/logging"
require "splunk/otel/common"
require "splunk/otel/instrumentation/action_pack"
