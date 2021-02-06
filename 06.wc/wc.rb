require 'optparse'

# 行数
def file_line(file)
  file.lines.count
end

# 単語数
def file_words(file)
  file.split(/\s+/).size
end

# バイトサイズ
 def byte_size(byte_date)
   byte_date.size
 end

# 標準入力の行数表示
def standard_input_lines(input)
  input.chomp.split("\n").count
end

# 標準入力の単語数表示
def standard_input_words(input)
  input.chomp.split(/\s+/).size
end

# 標準入力のバイトサイズ表示
def standard_input_byte_size(input)
  input.size
end

# トータル出力
 def multiple_files(filename, byte_date)
   lines_sum = 0
   words_sum = 0
   bytes_sum = 0
   filename.each do |n|
     file = File.read(n)
     byte_date = File.new(n)
     lines_sum += file.lines.count
     words_sum += file.split(/\s+/).size
     bytes_sum += byte_date.size
   end
   print lines_sum.to_s.rjust(8)
   print words_sum.to_s.rjust(8)
   print bytes_sum.to_s.rjust(8)
   puts " total"
 end

 # 行数だけのトータル出力
 def multiple_lines(filename)
   lines_sum = 0
   filename.each do |n|
     file = File.read(n)
     lines_sum += file.lines.count
   end
   print lines_sum.to_s.rjust(8)
   puts " total"
 end

option = ARGV.getopts("l")
filename = ARGV

# 標準入力の条件分岐
if filename.count == 0 && option["l"]
  input = $stdin.read
  puts standard_input_lines(input).to_s.rjust(8)
elsif filename.count == 0
  input = $stdin.read
  print standard_input_lines(input).to_s.rjust(8)
  print standard_input_words(input).to_s.rjust(8)
  puts standard_input_byte_size(input).to_s.rjust(8)
end

# ファイルが1つの場合の条件分岐
if filename.count == 1 && option["l"]
  file = File.read(ARGV[0])
  print file_line(file).to_s.rjust(8)
  puts " #{ARGV[0]}"
elsif filename.count == 1
  file = File.read(ARGV[0])
  byte_date = File.new(ARGV[0])
  print file_line(file).to_s.rjust(8)
  print file_words(file).to_s.rjust(8)
  print byte_size(byte_date).to_s.rjust(8)
  puts " #{ARGV[0]}"
end

# ファイルが複数の場合の条件分岐
if filename.count > 1 && option["l"]
  file = File.read(ARGV[0])
  filename.each do |n|
    file = File.read(n)
    print file_line(file).to_s.rjust(8)
    puts " #{ARGV[0]}"
  end
  multiple_lines(filename)
elsif filename.count > 1
  file = File.read(ARGV[0])
  byte_date = File.new(ARGV[0])
  filename.each do |n|
    file = File.read(n)
    byte_date = File.new(n)
    print file_line(file).to_s.rjust(8)
    print file_words(file).to_s.rjust(8)
    print byte_size(byte_date).to_s.rjust(8)
    puts " #{ARGV[0]}"
  end
  multiple_files(filename, byte_date)
end
