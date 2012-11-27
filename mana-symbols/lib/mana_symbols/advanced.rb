require 'mana_symbols/basic'

class ManaSymbols::Phyrexian < ManaSymbols::Basic
  def mana_name
    "#{SHORTCUT[@color]}/P"
  end
  # Either 2 life or the color
end

class ManaSymbols::Dual < ManaSymbols::Basic
  def mana_name
    "2/#{SHORTCUT[@color.first]}"
  end
  # Either 2 or the color
  def initialize(color)
    @color = Array(color) + [:none]
  end
end

class ManaSymbols::Hybrid < ManaSymbols::Basic
  # Either one of the two colors
  def mana_name
    @color.map {|c| SHORTCUT[c]}.join("/")
  end

  def initialize(*color)
    @color = color
  end
end

ManaSymbols::Tap = Class.new(ManaSymbols::Basic) do
  def initialize
  end

  def cost
    0
  end

  def mana_name
    "T"
  end

  def color
    :tap
  end
end.new
