# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/shot'
require_relative '../lib/frame'
require_relative '../lib/game'

class OopBowlingTest < Minitest::Test
  def test_shot_crass
    assert_equal 10, Shot.new('X').score
    assert_equal 5, Shot.new(5).score
  end

  def test_frame_crass
    assert_equal 10, Frame.new('X').frame_calc
    assert_equal 5, Frame.new(2, 3).frame_calc
  end

  def test_frame_strike?
    assert_equal true, Frame.new('X').frame_strike?
    assert_equal false, Frame.new(2, 4).frame_strike?
  end

  def test_frame_spare?
    assert_equal true, Frame.new(3, 7).frame_spare?
    assert_equal false, Frame.new(2, 4).frame_spare?
  end

  def test_game_crass
    assert_equal [%w[2 5], %w[2 5], %w[2 5], %w[2 5], %w[2 5], %w[2 5], %w[2 5], %w[2 0], ['X'], %w[2 8 4]],
                 Game.new('2,5,2,5,2,5,2,5,2,5,2,5,2,5,2,0,X,2,8,4').input_to_frames
  end

  def test_game_calc1
    assert_equal 139, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5').game_score
  end

  def test_game_calc2
    assert_equal 164, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X').game_score
  end

  def test_game_calc3
    assert_equal 107, Game.new('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4').game_score
  end

  def test_game_calc4
    assert_equal 134, Game.new('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0').game_score
  end

  def test_game_calc5
    assert_equal 300, Game.new('X,X,X,X,X,X,X,X,X,X,X,X').game_score
  end
end
