require 'set'
class ManaSymbols::ManaCost
  # This class combines mana symbols to a cost

  attr_reader :symbols
  alias :to_a :symbols

  def initialize(symbols)
    @symbols = symbols
  end

  def to_s
    symbols.join("")
  end

  def cost
    symbols.map(&:cost).reduce(:+)
  end
  alias :converted :cost

  def empty?
     symbols.empty?
  end

  def white?
    colors.include? :white
  end
  def blue?
    colors.include? :blue
  end
  def black?
    colors.include? :black
  end
  def red?
    colors.include? :red
  end
  def green?
    colors.include? :green
  end

  def snow?
    colors.include? :snow
  end
  def chaos?
    colors.include? :chaos
  end

  def tap?
    colors.include? :tap
  end

  def colors
    Set.new(Array(symbols).map(&:color).flatten)
  end

  # this one is for hybrid/phyrexian/dual
  def possible_colors
  end

  def colorless?
    colors.size == 0
  end
end
