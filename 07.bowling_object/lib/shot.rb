# frozen_string_literal: true

class Shot
  attr_reader :shot

  STRIKE = 10

  def initialize(shot)
    @shot = shot
  end

  def score
    @shot == 'X' ? STRIKE : @shot.to_i
  end
end
