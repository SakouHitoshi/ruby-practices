# frozen_string_literal: true

class Shot
  attr_accessor :shot
  STRIKE = 10

  def initialize(shot)
    @shot = shot
  end

  def score
    if shot == 'X'
      STRIKE
    else
      shot.to_i
    end
  end
end

puts Shot.new("X").score
