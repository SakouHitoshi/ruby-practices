require 'optparse'
require 'etc'

class Command
  attr_reader :files, :option

  def initialize(option)
    @option = option
    @files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files.reverse! if option['r']
  end

  def output
    option['l'] ? LongFormat.new(files).l_option_list : ShortFormat.new(files).display_arrange
  end
end

class ShortFormat
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def display_arrange
    array = files.each_slice(4).map { |sub_file_names| Array.new(4) { sub_file_names.shift } }
    array.transpose.each do |record|
      record.each do |display|
        print display.to_s.ljust(20)
      end
      print "\n"
    end
  end
end

class LongFormat
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def l_option_list
    total_blocks
    files.each do |file|
      print file_type(file)
      print file_permission(file)
      print File::Stat.new(file).nlink.to_s.ljust(2)
      print Etc.getpwuid(File.stat(file).uid).name.ljust(14)
      print Etc.getgrgid(File.stat(file).gid).name.ljust(6)
      print File::Stat.new(file).size.to_s.rjust(6)
      print File::Stat.new(file).mtime.strftime(' %m %d %H:%M ').rjust(12)
      puts file
    end
  end

  def total_blocks
    total_blocks = files.sum do |file|
      File::Stat.new(file).blocks
    end
    puts "total #{total_blocks}"
  end

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
end

option = ARGV.getopts('a', 'l', 'r')
Command.new(option).output
