# frozen_string_literal: true

module Splunk
  module Otel
    OUR_EXPORTERS_KEYS = ["jaeger-thrift-splunk"].freeze
    private_constant :OUR_EXPORTERS_KEYS

    # internal module for allowing our exporters to be set via ENV
    module ExporterExtensions
      def effective_splunk_jaeger_endpoint
        return "https://ingest.#{ENV["SPLUNK_REALM"]}.signalfx.com/v1/trace" if ENV["SPLUNK_REALM"]
        return ENV["OTEL_EXPORTER_JAEGER_ENDPOINT"] if ENV["OTEL_EXPORTER_JAEGER_ENDPOINT"]

        "http://127.0.0.1:9080/v1/trace"
      end

      def wrapped_exporters_from_env
        original_env_value = ENV.fetch("OTEL_TRACES_EXPORTER", "otlp")
        exporters_keys = original_env_value.split(",").map(&:strip)
        non_proprietary_exporters_keys = exporters_keys - OUR_EXPORTERS_KEYS

        ENV["OTEL_TRACES_EXPORTER"] = non_proprietary_exporters_keys.join(",")
        original_exporters = super
        ENV["OTEL_TRACES_EXPORTER"] = original_env_value

        original_exporters + proprietary_exporters(exporters_keys)
      end

      def proprietary_exporters(exporters_keys)
        (exporters_keys & OUR_EXPORTERS_KEYS).map do |exporter_key|
          case exporter_key
          when "jaeger-thrift-splunk"
            args = {
              endpoint: effective_splunk_jaeger_endpoint
            }
            fetch_exporter_with_args("jaeger-thrift-splunk", "OpenTelemetry::Exporter::Jaeger::CollectorExporter",
                                     **args)
          end
        end.compact
      end

      def fetch_exporter_with_args(name, class_name, **args)
        # TODO: warn if jaeger exporter gem is not present
        exporter = Kernel.const_get(class_name).new(**args)
        OpenTelemetry::SDK::Trace::Export::BatchSpanProcessor.new exporter
      rescue NameError
        OpenTelemetry.logger.warn "The #{name} exporter cannot be configured" \
                                  "- please add opentelemetry-exporter-#{name} to your Gemfile" \
                                  ", spans will not be exported.."
        nil
      end
    end
  end
end
