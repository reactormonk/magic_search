require 'set'
class ManaSymbols::ManaCost
  # This class combines mana symbols to a cost

  attr_reader :symbols
  alias :to_a :symbols

  def initialize(symbols)
    @symbols = symbols
  end

  def cost
    @symbols.map(&:cost).reduce(:+)
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

  def colors
    Set.new(@symbols.map(&:color)).compact
  end

  # this one is for multicolor symbols or phyrexian mana
  def possible_colors
  end

  def colorless?
    colors.size == 0
  end
end
