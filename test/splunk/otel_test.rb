# frozen_string_literal: true

require "test_helper"

module Splunk
  class OtelTest < Test::Unit::TestCase
    test "VERSION" do
      assert do
        ::Splunk::Otel.const_defined?(:VERSION)
      end
    end

    test "something useful" do
      assert_equal("actual", "actual")
    end
  end
end
