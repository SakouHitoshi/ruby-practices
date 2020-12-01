#!/usr/bin/env ruby
require "optparse" #optparseクラスのデータを受け取る
require 'date' #dateクラスのデータを受け取る
day = Date.today #今日の情報
options = ARGV.getopts("y:", "m:") #引数付きショートネームオプションの指定

if options["y"] #もし"y"に値が入力されたら
  year = options["y"].to_i #入力値をyear変数に代入
else
  year = day.year #入力されないと今年のデータになる
end

if options["m"] #もし"m"に値が入力されたら
  month = options["m"].to_i #入力値を今年をmonth変数に代入
else
  month = day.mon #入力されないと今月のデータになる
end

firstday_week = Date.new(year,month,1).wday #今月1日の曜日を取得(0~6)
lastday = Date.new(year,month,-1).day #今月の最終日を取得
week = "日 月 火 水 木 金 土" #曜日を表示

puts  "#{month}月 #{year}".center(20) #month変数とyear変数を出力
puts week #曜日を出力
print "   " * firstday_week #1日までの空白を出力

(1..lastday).each do |day| #1日から最終日まで繰り返し
  print day.to_s.rjust(2) + " " #文字列に変換した後に日付を右寄せで表示
  firstday_week = firstday_week + 1 #1日目の曜日数から1足していく
  if firstday_week % 7 == 0 #7で割り切れる数は土曜日なので土曜日まで表示したら改行
    print "\n"
  end
end
