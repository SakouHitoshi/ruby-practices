# frozen_string_literal: true

require 'optparse'
require 'etc'

option = ARGV.getopts('a', 'l', 'r')

# a,rオプションの表示を整える
def display_arrange(file_names)
  array = file_names.each_slice(4).map do |file|
    case file.size
    when 1
      file.push(nil, nil, nil)
    when 2
      file.push(nil, nil)
    when 3
      file.push(nil)
    else
      file
    end
  end
  array.transpose.each do |record|
    record.each do |display|
      print display.to_s.ljust(20)
    end
    print "\n"
  end
end

# ブロック数計算
def total_blocks(file_names)
  total_blocks = file_names.sum do |file|
    File::Stat.new(file).blocks
  end
  puts "total #{total_blocks}"
end

# ファイルタイプの取得
def file_type(file)
  lists = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'f',
    'link' => 'l',
    'socket' => 's',
    'unknown' => '?'
  }
  lists[File::Stat.new(file).ftype]
end

# パーミッションの取得
def file_permission(file)
  permission = File::Stat.new(file).mode.to_s(8).slice(-3, 3).chars
  permission.map! do |n|
    lists = {
      '7' => 'rwx',
      '6' => 'rw-',
      '5' => 'r-x',
      '4' => 'r--',
      '3' => '-wx',
      '2' => '-w-',
      '1' => '--x',
      '0' => '---'
    }
    lists[n]
  end
  permission.join
end

# a,rオプションのデータ取得
file_names =
  if option['a']
    Dir.glob('*', File::FNM_DOTMATCH)
  else
    Dir.glob('*')
  end
if option['r']
  file_names.sort.reverse
else
  file_names.sort
end

# lオプションの出力
if option['l']
  total_blocks(file_names)
  file_names.each do |file|
    print file_type(file)
    print file_permission(file)
    print File::Stat.new(file).nlink.to_s.ljust(2)
    print Etc.getpwuid(File.stat('./').uid).name.ljust(14) # オーナー名
    print Etc.getgrgid(File.stat('./').gid).name.ljust(6) # グループ名
    print File::Stat.new(file).size.to_s.rjust(6)
    print File::Stat.new(file).mtime.strftime(' %m %d %H:%M ').rjust(12) # 最終更新時刻
    puts file # ファイル名
  end
else # a,rオプションの出力
  display_arrange(file_names)
end
