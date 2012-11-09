class ManaSymbols::Basic
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def cost
    1
  end

  class Gray < self
    attr_reader :cost

    def initialize(cost)
      @cost = cost
    end

    def color
      nil
    end
  end

  W = new(:white)
  U = new(:blue)
  B = new(:black)
  R = new(:red)
  G = new(:green)
end
