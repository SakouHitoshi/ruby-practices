require 'minitest/autorun'
require 'optparse'
require_relative '../lib/ls_object'

class LsObjectTest < Minitest::Test
  def test_normal_ls
    expected = <<~TEXT.chomp
      dummy01 dummy02 dummy03 dummy04 dummy05 dummy06 dummy07 dummy08 dummy09 dummy10 lib     test
    TEXT
    assert_equal expected, Command.new.output
  end

  def test_a_option_ls
    expected = <<~TEXT.chomp
      .        ..       .gitkeep dummy01  dummy02  dummy03  dummy04  dummy05  dummy06  dummy07  dummy08  dummy09  dummy10  lib      test
    TEXT
    assert_equal expected, Command.new('a').output
  end

  def test_r_option_ls
    expected = <<~TEXT.chomp
      test    lib     dummy10 dummy09 dummy08 dummy07 dummy06 dummy05 dummy04 dummy03 dummy02 dummy01
    TEXT
    assert_equal expected, Command.new('r').output
  end

end
