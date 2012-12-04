require 'mana_symbols/advanced'
module ManaSymbols
  def self.parse(string)
    Parser.new(string).cost
  end

  def self.parse_string(string)
    StringParser.new(string)
  end

  # screw reflection
  LOOKUP = {
    'W' => Basic::W,
    'U' => Basic::U,
    'B' => Basic::B,
    'R' => Basic::R,
    'G' => Basic::G,
    'X' => Basic::X,
    'T' => Tap,

    # Advanced symbols
    'C' => C,
    'S' => S,

    "2/B" => Dual.new(:black),
    "2/G" => Dual.new(:green),
    "2/R" => Dual.new(:red),
    "2/U" => Dual.new(:blue),
    "2/W" => Dual.new(:white),

    "B/P" => Phyrexian.new(:black),
    "G/P" => Phyrexian.new(:green),
    "R/P" => Phyrexian.new(:red),
    "U/P" => Phyrexian.new(:blue),
    "W/P" => Phyrexian.new(:white),

    # More combinations exist, but the order is defined.
    "B/G" => Hybrid.new(:black, :green),
    "B/R" => Hybrid.new(:black, :red),
    "G/U" => Hybrid.new(:green, :blue),
    "G/W" => Hybrid.new(:green, :white),
    "R/G" => Hybrid.new(:red, :green),
    "R/W" => Hybrid.new(:red, :white),
    "U/B" => Hybrid.new(:blue, :black),
    "U/R" => Hybrid.new(:blue, :red),
    "W/B" => Hybrid.new(:white, :black),
    "W/U" => Hybrid.new(:white, :blue)
  }
  LOOKUP.default_proc = proc {|hash, key|
    # better than silent fail
    hash[key] = Basic::Gray.new(Integer(key))
  }

  class Parser
    attr_reader :cost

    def initialize(string)
      @cost = ManaCost.new(string[1..-2].split("}{").map{|element| lookup(element)})
    end

    def lookup(element)
      ManaSymbols::LOOKUP[element]
    end
  end

  class StringParser
    MANA_REGEXP = /(\{[^ ]+\})/
    def initialize(string)
      @array = string.split(MANA_REGEXP).each_slice(2)
        .map {|(str, mana)| [str, mana ? ManaSymbols.parse(mana) : nil]}
        .flatten.compact.reject(&:empty?)
    end

    def to_s
      @array.map(&:to_s)
    end

    def to_a
      @array
    end
  end

  SHORTCUT = {
    blue: 'U',
    black: 'B',
    white: 'W',
    green: 'G',
    red: 'R',
  }
end
