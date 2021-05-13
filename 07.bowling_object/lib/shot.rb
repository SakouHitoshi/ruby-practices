class Shot
  attr_reader :shot
  STRIKE = 10

  def initialize(shot)
    @shot = shot == 'X' ? STRIKE : shot.to_i
  end

  def score
    shot == 'X' ? 10 : shot.to_i
  end
end
