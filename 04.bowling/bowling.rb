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

  end
end
if frames[9] == [10] && frames[10] == [10] && frames[11] == [10]
  frames[9].concat frames[10] + frames[11]
  frames.delete_at(10)
  frames.delete_at(10)
elsif frames[9] == [10] && frames[10] == [10]
  frames[9].concat frames[10]
  frames[9] << scores[-1].to_i
  frames.delete_at(10)
elsif frames[9] == [10]
  frames[9].concat frames[10]
  frames.delete_at(10)
elsif frames[9] != [10] && frames[9].sum == 10 && frames[10] == [10]
  frames[9].concat frames[10]
  frames.delete_at(10)
elsif frames[9] != [10] && frames[9].sum == 10
  frames[9] << scores[-1].to_i
  frames.delete_at(10)
end

point = 0
frames.each_with_index do |f, i|
  point += if i != 8 && i != 9
             if frames[i][0] == 10 && frames[i + 1][0] == 10 && frames[i + 2][0] == 10
               30
             elsif frames[i][0] == 10 && frames[i + 1][0] == 10
               20 + frames[i + 2][0]
             elsif frames[i][0] == 10
               10 + frames[i + 1][0] + frames[i + 1][1]
             elsif f.sum == 10 && frames[0] != 10
               10 + frames[i + 1][0]
             else
               f.sum
             end
           elsif i == 8
             if frames[i][0] == 10 && frames[i + 1][0] == 10 && frames[i + 1][1] == 10
               30
             elsif frames[i][0] == 10 && frames[i + 1][0] == 10
               20 + frames[i + 1][1]
             elsif frames[i][0] == 10
               10 + frames[i + 1][0] + frames[i + 1][1]
             elsif f.sum == 10 && frames[0] != 10
               10 + frames[i + 1][0]
             else
               f.sum
             end
           else
             f.sum
           end
end
p point
