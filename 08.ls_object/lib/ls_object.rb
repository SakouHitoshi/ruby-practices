require 'optparse'
require 'etc'

class Command
  def initialize

  end
end

class FileDate
  def initialize

  end
end

class Option
  def initialize(option = ARGV.getopts('arl'))
    @option = option
  end

  def a_option
    @option['a']
  end

  def r_option
    @option['r']
  end

  def l_option
    @option['l']
  end
end

class NormalFormatter
  def initialize

  end
end

class AllFile
  def initialize

  end
end

class LongFormatter
  def initialize

  end
end

class Reversing
  def initialize

  end
end
