require 'io/console'
require 'optparse'
require 'etc'

class Command
  attr_reader :files, :option, :width

  def initialize(option)
    @width = IO.console.winsize[1]
    @option = option
    @files = option['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files.reverse! if option['r']
  end

  def output
    if option['l']
      LongFormat.new(files).l_option_list
    else
      puts ShortFormat.new(files, width).column_decision(files, width)
    end
  end
end

class ShortFormat
  attr_reader :files, :width

  def initialize(files, width)
    @width = width
    @files = files
  end

  def column_decision(files, width)
    max_filename_count = files.map(&:size).max
    col_count = width / (max_filename_count + 1)
    row_count = col_count.zero? ? 1 : (files.count.to_f / col_count).ceil
    transposed_file_paths = safe_transpose(files.each_slice(row_count).to_a)
    format_table(transposed_file_paths, max_filename_count)
  end

  def safe_transpose(nested_file_names)
    nested_file_names[0].zip(*nested_file_names[1..-1])
  end

  def format_table(file_paths, max_filename_count)
    file_paths.map do |row_files|
      render_short_format_row(row_files, max_filename_count)
    end.join("\n")
  end

  def render_short_format_row(row_files, max_filename_count)
    row_files.map do |file_path|
      basename = file_path ? File.basename(file_path) : ''
      basename.ljust(max_filename_count + 1)
    end.join.rstrip
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
