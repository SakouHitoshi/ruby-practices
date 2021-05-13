require 'minitest/autorun'
require_relative '../lib/shot'
require_relative '../lib/frame'


class OopBowlingTest < Minitest::Test
  def test_shot
    assert_equal 10, Shot.new("X").score
    assert_equal 5, Shot.new(5).score
  end

  def test_frame
    assert_equal 10, Frame.new("X").frame_calc
    assert_equal 10, Frame.new(3, 7).frame_calc
    assert_equal 5, Frame.new(2, 3).frame_calc
  end
end
