require 'mana_symbols/basic'

module ManaSymbols
  class Phyrexian < Basic
    def mana_name
      "#{SHORTCUT[@color]}/P"
    end
    # Either 2 life or the color
  end

  class Dual < Basic
    def mana_name
      "2/#{SHORTCUT[@color.first]}"
    end
    # Either 2 or the color
    def initialize(color)
      @color = Array(color) + [:none]
    end
  end

  class Hybrid < Basic
    # Either one of the two colors
    def mana_name
      @color.map {|c| SHORTCUT[c]}.join("/")
    end

    def initialize(*color)
      @color = color
    end
  end

  Tap = Class.new(Basic) do
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


  S = Basic.new(:snow).tap do |snow|
    def snow.mana_name
      'S'
    end
  end

  C = Basic.new(:chaos).tap do |chaos|
    def chaos.mana_name
      'C'
    end
  end
end
