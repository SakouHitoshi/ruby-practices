# frozen_string_literal: true

score = ARGV[0]
scores = score.chars

frames = []
frame = []

scores.each do |s|
  frame << if s == 'X'
             10
           else
             s.to_i
           end
  if frame.count == 1 && frame.first == 10
    frames << frame
    frame = []
  elsif frame.count == 2
    frames << frame
    frame = []
  elsif frames.size >= 9
    frames << frame
    frame = []
  end
end

point = 0
frames.each_with_index do |f, i|
  point += if i < 9 && frames[i][0] == 10 && frames[i + 1][0] == 10
             20 + frames[i + 2][0]
           elsif i == 8 && frames[i][0] == 10
             10 + frames[i + 1][0] + frames[i + 2][0]
           elsif i < 9 && frames[i][0] == 10
             10 + frames[i + 1][0] + frames[i + 1][1]
           elsif i < 9 && f.sum == 10 && frames[0] != 10
             10 + frames[i + 1][0]
           else
             f.sum
           end
end
p point
