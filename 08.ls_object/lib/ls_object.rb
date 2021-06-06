# frozen_string_literal: true

require 'io/console'
require 'optparse'
require 'etc'

class Command
  attr_reader :terminal_width, :long_format, :reverse, :include_dot_file

  def initialize(terminal_width: IO.console.winsize[1], long_format: false, reverse: false, include_dot_file: false)
    @terminal_width = terminal_width
    @long_format = long_format
    @reverse = reverse
    @include_dot_file = include_dot_file
  end

  def output
    files = include_dot_file ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
    files.reverse! if reverse
    long_format ? LongFormat.new(files).long_display : ShortFormat.new(files, terminal_width).short_display
  end
end

class ShortFormat
  attr_reader :terminal_width

  def initialize(files, terminal_width)
    @basename = files.map { |file| File.basename(file) }
    @terminal_width = terminal_width
    @files = files
  end

  def short_display
    display_files = @basename.each_slice(lines).map { |file| file }
    (lines - display_files.last.size).times do
      display_files.last.push ''
    end
    files_transpose = display_files.transpose
    files_transpose.map { |file| format_lines(file) }.join(("\n"))
  end

  def lines
    (@basename.size / columns).ceil
  end

  def columns
    col_count = terminal_width / (max_filename_length + 1)
    col_count.zero? ? 1 : col_count.to_f
  end

  def max_filename_length
    @basename.max_by(&:length).size
  end

  def format_lines(files)
    files.map { |file| file.ljust(max_filename_length + 1) }.join.rstrip
  end
end

class LongFormat
  attr_reader :files

  def initialize(files)
    @files = files
  end

  def long_display
    files_date = files.map { |file| build_data(file) }
    max_lengths = max_lengths(files_date)
    total = files_date.sum { |file| file[:block].to_i }
    total_line = "total #{total}"
    body = files_date.map { |file| formatted_for_display(file, *max_lengths) }
    [total_line, *body].join("\n")
  end

  def build_data(file)
    {
      type: file_type(file),
      permission: file_permission(file),
      links: File.lstat(file).nlink.to_s,
      user: Etc.getpwuid(File.lstat(file).uid).name,
      group: Etc.getgrgid(File.lstat(file).gid).name,
      size: File.lstat(file).size.to_s,
      timestamp: time_stamp(file),
      file: File.basename(file),
      block: File.lstat(file).blocks.to_i
    }
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

  def time_stamp(file)
    timestamp = File.lstat(file).mtime
    "#{timestamp.strftime('%-m').rjust(2)} #{timestamp.strftime('%e %H:%M')}"
  end

  def max_lengths(files)
    keys = %i[links user group size]
    keys.map { |key| files.map { |file| file[key].size }.max }
  end

  def formatted_for_display(file, links_max_length, user_max_length, group_max_length, size_max_length)
    [
      file[:type],
      file[:permission],
      "  #{file[:links].rjust(links_max_length)}",
      " #{file[:user].ljust(user_max_length)}",
      "  #{file[:group].ljust(group_max_length)}",
      "  #{file[:size].rjust(size_max_length)}",
      " #{file[:timestamp]}",
      " #{file[:file]}",
      file[:linked_file]
    ].join
  end
end

opt = OptionParser.new
params = { long_format: false, reverse: false, include_dot_file: false }
opt.on('-a') { |v| params[:include_dot_file] = v }
opt.on('-l') { |v| params[:long_format] = v }
opt.on('-r') { |v| params[:reverse] = v }
opt.parse!(ARGV)
puts Command.new(**params).output
