require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = Shot.new(first_shot).score
    @second_shot = Shot.new(second_shot).score
    @third_shot = Shot.new(third_shot).score
  end

  def frame_calc
    frame_point = @first_shot
    frame_point += @second_shot if @second_shot
    frame_point += @third_shot if @third_shot
    frame_point
  end

  def frame_strike?
    @first_shot == 10
  end

  def frame_spare?
    [@first_shot, @second_shot].sum == 10 && !frame_strike?
  end
end
