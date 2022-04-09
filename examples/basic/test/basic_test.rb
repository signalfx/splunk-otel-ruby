# frozen_string_literal: true

require "test_helper"

class BasicTest < Test::Unit::TestCase
  test "VERSION" do
    assert do
      ::Basic.const_defined?(:VERSION)
    end
  end

  test "something useful" do
    x = Basic.some_spans
    assert_equal("expected", x)
  end
end
