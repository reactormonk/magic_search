require 'mana_symbols/basic'

class ManaSymbols::Phyrexian < ManaSymbols::Basic
  # Either 2 life or the color
end

class ManaSymbols::Dual < ManaSymbols::Basic
  # Either 2 or the color
  def initialize(color)
    @color = Array(color) + [:none]
  end
end

class ManaSymbols::Hybrid < ManaSymbols::Basic
  # Either one of the two colors
  def initialize(*color)
    @color = color
  end
end

ManaSymbols::Tap = Class.new do
  def cost
    0
  end

  def color
    :tap
  end
end.new
