# frozen_string_literal: true

require 'optparse'
require 'etc'

option = ARGV.getopts('a', 'l', 'r')

# a,rオプションのデータ取得
def list_file_paths(option)
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
end

# ブロック数計算
def total_blocks(option)
  total_blocks = list_file_paths(option).sum do |file|
    File::Stat.new(file).blocks
  end
  print "total #{total_blocks}"
end

# lオプションの出力
if option['l']
  puts total_blocks(option)
  list_file_paths(option).each do |file|
    l_file = File::Stat.new(file)
    file_type = l_file.ftype # ファイルタイプ
    hard_link = l_file.nlink.to_s # ハードリンク
    user = Etc.getpwuid(File.stat('./').uid).name # オーナー名
    group = Etc.getgrgid(File.stat('./').gid).name # グループ名
    file_size = l_file.size.to_s # ファイルサイズ
    time = l_file.mtime # 最終更新日の情報
    print '-' if file_type == 'file'
    print 'd' if file_type == 'directory'
    print 'c' if file_type == 'characterSpecial'
    print 'b' if file_type == 'blockSpecial'
    print 'p' if file_type == 'fifo'
    print 'l' if file_type == 'link'
    print 's' if file_type == 'socket'
    print ' ' if file_type == 'unknown'
    mode_octal = l_file.mode.to_s(8) # modeを8進数に変換
    binary = mode_octal[-3].to_i.to_s(2) # 所有者権限を2進数に変換
    rwx = ''
    rwx += (binary[0] == '1' ? 'r' : '-')
    rwx += (binary[1] == '1' ? 'w' : '-')
    rwx += (binary[2] == '1' ? 'x' : '-')
    print rwx
    binary = mode_octal[-2].to_i.to_s(2) # グループ権限を2進数に変換
    rwx = ''
    rwx += (binary[0] == '1' ? 'r' : '-')
    rwx += (binary[1] == '1' ? 'w' : '-')
    rwx += (binary[2] == '1' ? 'x' : '-')
    print rwx
    binary = mode_octal[-1].to_i.to_s(2) # その他のユーザー権限を2進数に変換
    rwx = ''
    rwx += (binary[0] == '1' ? 'r' : '-')
    rwx += (binary[1] == '1' ? 'w' : '-')
    rwx += (binary[2] == '1' ? 'x' : '-')
    print rwx.ljust(4)
    print hard_link.ljust(2)
    print user.ljust(14)
    print group.ljust(6)
    print file_size.rjust(6)
    print time.strftime(' %m %d %H:%M ').rjust(12) # 最終更新時刻
    puts file # ファイル名
  end
else # a,rオプションの出力
  array = list_file_paths(option).each_slice(4).map do |file|
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
