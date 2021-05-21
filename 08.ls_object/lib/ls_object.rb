require 'optparse'
require 'etc'

class Command
  attr_reader :files

  def initialize
    @files = Dir.glob('*').sort
  end

  def output
    if @option.l_option
      LongFormat.new(@files)
    else
      ShortFormat.new(@files).display_arrange
    end
  end
end

class Opition
  def initialize(option)
    @option = option
  end

  def option_files
    file_names = @option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    @option['r'] ? file_names.sort.reverse : file_names.sort
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

  def initialize
    @files = files
  end
end

option = ARGV.getopts('a', 'l', 'r')
files = Opition.new(option).option_files
ShortFormat.new(files).display_arrange
