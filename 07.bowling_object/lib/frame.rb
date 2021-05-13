require_relative 'shot'

class Frame
  attr_accessor :first_shot, :second_shot

  def initialize(first_pinfall, second_pinfall)
    @first_shot = Shot.new(first_pinfall)
    @second_shot = Shot.new(second_pinfall)
  end

  def frame_calc
    [first_shot.score, second_shot.score].sum
  end

  def frame_strike?
    first_shot.score == 10
  end

  def frame_spare?
    [first_shot.score, second_shot.score].sum == 10
  end
end

puts Frame.new(6, 4).frame_calc
