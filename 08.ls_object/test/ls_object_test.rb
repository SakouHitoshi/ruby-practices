# frozen_string_literal: true

require 'minitest/autorun'
require 'optparse'
require_relative '../lib/ls_object'

class LsObjectTest < Minitest::Test
  def test_normal_ls
    expected = <<~TEXT.chomp
      dummy01 dummy02 dummy03 dummy04 dummy05 lib     test
    TEXT
    assert_equal expected, Command.new(terminal_width: 80).output
  end

  def test_a_option_ls
    expected = <<~TEXT.chomp
      .        .gitkeep dummy02  dummy04  lib
      ..       dummy01  dummy03  dummy05  test
    TEXT
    assert_equal expected, Command.new(terminal_width: 80, include_dot_file: true).output
  end

  def test_r_option_ls
    expected = <<~TEXT.chomp
      test    lib     dummy05 dummy04 dummy03 dummy02 dummy01
    TEXT
    assert_equal expected, Command.new(terminal_width: 80, reverse: true).output
  end

  def test_l_option_ls
    expected = <<~TEXT.chomp
      total 0
      -rw-r--r--  1 sakouhitoshi  staff   0  5 21 09:48 dummy01
      -rw-r--r--  1 sakouhitoshi  staff   0  5 21 09:48 dummy02
      -rw-r--r--  1 sakouhitoshi  staff   0  5 21 09:49 dummy03
      -rw-r--r--  1 sakouhitoshi  staff   0  5 21 09:49 dummy04
      -rw-r--r--  1 sakouhitoshi  staff   0  5 21 09:49 dummy05
      drwxr-xr-x  3 sakouhitoshi  staff  96  6 10 16:55 lib
      drwxr-xr-x  3 sakouhitoshi  staff  96  6 10 17:02 test
    TEXT
    assert_equal expected, Command.new(long_format: true).output
  end
end
