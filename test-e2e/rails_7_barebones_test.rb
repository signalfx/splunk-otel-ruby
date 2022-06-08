# frozen_string_literal: true

require "test-unit"
require "net/http"
require "json"

module Splunk
  class Rails7BarebonesTest < Test::Unit::TestCase
    test "generates spans" do
      app_host = ENV.fetch "APP_HOST", "localhost"
      app_port = ENV.fetch("APP_PORT", "3000").to_i
      collector_host = ENV.fetch "COLLECTOR_HOST", "localhost"
      collector_port = ENV.fetch("COLLECTOR_PORT", "8378").to_i

      Net::HTTP.get(app_host, '/', app_port)

      response = Net::HTTP.get(collector_host, '/?timeout=20&count=1', collector_port)
      spans = JSON.parse(response)
      assert spans.count >= 1

      assert spans.all?{|span| span["traceId"].to_s != ""}
      assert spans.all?{|span| span["spanId"].to_s != ""}
      assert spans.all?{|span| span["operationName"].to_s != ""}
    end
  end
end
