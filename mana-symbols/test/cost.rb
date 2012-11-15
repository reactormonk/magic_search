require_relative 'spec_helper'
describe ManaSymbols::ManaCost do
  it "should say green manacosts are green" do
    ManaSymbols::ManaCost.new(ManaSymbols::Basic::G).green?.must_equal true
  end
  it "should say white manacosts are not green" do
    ManaSymbols::ManaCost.new(ManaSymbols::Basic::W).green?.must_equal false
  end
  it "should say green manacosts are green, even with multicolor" do
    ManaSymbols::ManaCost.new([ManaSymbols::Basic::G, ManaSymbols::Basic::W]).green?.must_equal true
  end
end
