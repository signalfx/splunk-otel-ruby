# frozen_string_literal: true

ENV["OTEL_TRACES_EXPORTER"] = "console"
Splunk::Otel.configure(service_name: "rails-7-barebones", auto_instrument: true)
