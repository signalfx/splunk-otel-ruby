# frozen_string_literal: true

require "test-unit"
require "net/http"
require "json"

module Splunk
  class Rails7BarebonesTest < Test::Unit::TestCase
    test "generates spans" do
      Net::HTTP.get("localhost", '/', 3000)

      response = Net::HTTP.get("localhost", '/?timeout=20&count=1', 8378)
      spans = JSON.parse(response)
      assert spans.count >= 1

      assert spans.all?{|span| span["traceId"].to_s != ""}
      assert spans.all?{|span| span["spanId"].to_s != ""}
      assert spans.all?{|span| span["operationName"].to_s != ""}
    end
  end
end
