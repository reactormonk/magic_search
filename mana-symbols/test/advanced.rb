require_relative 'spec_helper'

describe ManaSymbols do
  it "should parse phyexian mana {W/P}" do
    target = ManaSymbols::parse("{W/P}")
    target.colors.must_equal Set.new([:white])
  end
  it "should parse dual mana {U/R}" do
    target = ManaSymbols::parse("{U/R}")
    target.colors.must_equal Set.new([:blue, :red])
  end
  it "should parse double mana {2/R}" do
    target = ManaSymbols::parse("{2/R}")
    target.colors.must_equal Set.new([:none, :red])
  end
  it "should parse tap {T}" do
    target = ManaSymbols::parse("{T}")
    target.tap?.must_equal true
  end
end
