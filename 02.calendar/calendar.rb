require 'optparse' # optparseクラスのデータを受け取る
require 'date' # dateクラスのデータを受け取る
day = Date.today # 今日の情報
options = ARGV.getopts('y:', 'm:') # 引数付きショートネームオプションの指定

year = if options['y'] # もし"y"に値が入力されたら
         options['y'].to_i # 入力値をyear変数に代入
       else
         day.year # 入力されないと今年のデータになる
       end

month = if options['m'] # もし"m"に値が入力されたら
          options['m'].to_i # 入力値を今年をmonth変数に代入
        else
          day.mon # 入力されないと今月のデータになる
        end

firstday = Date.new(year, month, 1) # 今月の1日を取得
firstday_week = Date.new(year, month, 1).wday # 今月1日の曜日を取得(0~6)
lastday = Date.new(year, month, -1) # 今月の最終日を取得
week = '日 月 火 水 木 金 土' # 曜日を表示

puts "#{month}月 #{year}".center(20) # month変数とyear変数を出力
puts week # 曜日を出力
print '   ' * firstday_week # 1日までの空白を出力

(firstday..lastday).each do |d| # 1日から最終日まで繰り返し
  print d.day.to_s.rjust(2) + ' ' # 文字列に変換した後に日付を右寄せで表示
  print "\n" if d.saturday? # 土曜日まで表示したら改行
end
print "\n"
