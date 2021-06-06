# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  attr_accessor :input

  def initialize(input)
    @input = input
  end

  def game_score
    frame_points.sum
  end

  def frame_points
    create_to_frame_class.map.with_index(1) do |frame, index|
      calc_frame_score(create_to_frame_class, frame, index)
    end
  end

  def create_to_frame_class
    input_to_frames.each.map { |frame| Frame.new(*frame) }
  end

  def input_to_frames
    pinfalls = @input.split(',')
    frames = []
    frame = []
    pinfalls.each do |pinfall|
      frame << pinfall
      if frames.size != 10
        if pinfall == 'X' || frame.size >= 2
          frames << frame.clone
          frame.clear
        end
      else
        frames.last << pinfall
      end
    end
    frames
  end

  def calc_frame_score(frames, frame, index)
    if frame.frame_strike? && !last_frame?(index)
      frame.calc + strike_bonus(frames, index)
    elsif frame.frame_spare? && !last_frame?(index)
      frame.calc + spare_bonus(frames, index)
    else
      frame.calc
    end
  end

  def last_frame?(index)
    index == 10
  end

  def strike_bonus(frames, index)
    next_frame = next_frame(frames, index)
    after_next_frame = after_next_frame(frames, index)
    if frame_before_last?(index)
      next_frame.first_shot + next_frame.second_shot
    elsif next_frame.frame_strike?
      next_frame.calc + after_next_frame.first_shot
    else
      next_frame.calc
    end
  end

  def spare_bonus(frames, index)
    next_frame = next_frame(frames, index)
    next_frame.first_shot
  end

  def frame_before_last?(index)
    index == 9
  end

  def next_frame(frames, index)
    frames[index]
  end

  def after_next_frame(frames, index)
    frames[index.next]
  end
end
