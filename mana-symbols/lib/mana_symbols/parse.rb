module ManaSymbols
  def self.parse(string)
    Parser.new(string).cost
  end

  # screw reflection
  LOOKUP = {
    'W' => Basic::W,
    'U' => Basic::U,
    'B' => Basic::B,
    'R' => Basic::R,
    'G' => Basic::G
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
end
