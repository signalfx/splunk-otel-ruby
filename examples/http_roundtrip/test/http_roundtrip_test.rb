# frozen_string_literal: true

require "test_helper"

class HttpRoundtripTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::HttpRoundtrip.const_defined?(:VERSION)
    end
  end

  test "spans created for http request" do
    exporter = HttpRoundtrip.run
    spans = exporter.finished_spans

    # one for HTTP CONNECT that httpclient does, then the request to example.com
    # and the outer span "span-1"
    assert_equal(3, spans.size)
  end
end
