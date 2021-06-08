# frozen_string_literal: true

class Shot
  STRIKE = 10

  def initialize(shot)
    @shot = shot
  end

  def score
    @shot == 'X' ? STRIKE : @shot.to_i
  end
end
