require 'mana_symbols/basic'

class ManaSymbols::Phyrexian < ManaSymbols::Basic
  def to_s
    "{#{SHORTCUT[@color]}/P}"
  end
  # Either 2 life or the color
end

class ManaSymbols::Dual < ManaSymbols::Basic
  def to_s
    "{2/#{SHORTCUT[@color.first]}}"
  end
  # Either 2 or the color
  def initialize(color)
    @color = Array(color) + [:none]
  end
end

class ManaSymbols::Hybrid < ManaSymbols::Basic
  # Either one of the two colors
  def to_s
    "{" + @color.map {|c| SHORTCUT[c]}.join("/") + "}"
  end

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
