class ManaSymbols::Basic
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def mana_name
    SHORTCUT[color]
  end

  def to_s
    name = mana_name
    name.length > 1 ? "{#{name}}" : name
  end

  def cost
    1
  end

  class Gray < self
    attr_reader :cost

    def mana_name
      @cost.to_s
    end

    def initialize(cost)
      @cost = cost
    end

    def color
      :none
    end
  end

  X = Gray.new(3).tap do |variable|
    def variable.to_s
      "X"
    end

    def variable.mana_name
      "X"
    end
    # add more logic to colorless mana here
  end
  
  W = new(:white)
  U = new(:blue)
  B = new(:black)
  R = new(:red)
  G = new(:green)

  SHORTCUT = {
              blue: 'U',
              black: 'B',
              white: 'W',
              green: 'G',
              red: 'R',
             }
end
