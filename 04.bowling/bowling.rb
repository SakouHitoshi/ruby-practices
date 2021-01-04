# frozen_string_literal: true

score = ARGV[0]
scores = score.chars

frames = []
frame = []
STRIKE = 10
NINE_FRAME = 9

scores.each do |s|
  frame << if s == 'X'
             STRIKE
           else
             s.to_i
           end
  if frame.count == 1 && frame.first == STRIKE
    frames << frame
    frame = []
  elsif frame.count == 2
    frames << frame
    frame = []
  elsif frames.size >= NINE_FRAME
    frames << frame
    frame = []
  end
end

if frames[11]
  frames[9].concat frames[10] + frames[11]
  frames.delete_at(10)
  frames.delete_at(10)
elsif frames[10]
  frames[9].concat frames[10]
  frames.delete_at(10)
end

point = 0
frames.each_with_index do |f, i|
  point += if i == 8 && frames[i][0] == STRIKE && frames[i + 1][0] == STRIKE
             STRIKE * 2 + frames[i + 1][1]
           elsif i < NINE_FRAME && frames[i][0] == STRIKE && frames[i + 1][0] == STRIKE
             STRIKE * 2 + frames[i + 2][0]
           elsif i < NINE_FRAME && frames[i][0] == STRIKE
             STRIKE + frames[i + 1][0] + frames[i + 1][1]
           elsif i < NINE_FRAME && f.sum == STRIKE && frames[0] != STRIKE
             STRIKE + frames[i + 1][0]
           else
             f.sum
           end
end
p point
