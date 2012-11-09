require 'minitest/spec'
require 'minitest/autorun'
require_relative 'spec_helper'

describe ManaSymbols do
  it "should parse the basic colors" do
    %w(W R U B G).each do |color|
      ManaSymbols::parse("{#{color}}").to_a.must_equal [ManaSymbols::LOOKUP[color]]
    end
  end
  it "should parse multiple of the basic colors" do
    { "{W}{W}" => [ManaSymbols::Basic::W, ManaSymbols::Basic::W],
      "{W}{R}" => [ManaSymbols::Basic::W, ManaSymbols::Basic::R],
      "{U}{U}" => [ManaSymbols::Basic::U, ManaSymbols::Basic::U],
      "{G}{B}" => [ManaSymbols::Basic::G, ManaSymbols::Basic::B],
      "{B}{G}" => [ManaSymbols::Basic::B, ManaSymbols::Basic::G],
      "{G}{G}" => [ManaSymbols::Basic::G, ManaSymbols::Basic::G],
      "{R}{R}{G}" => [ManaSymbols::Basic::R, ManaSymbols::Basic::R, ManaSymbols::Basic::G]
    }.each do |(string, result)|
      ManaSymbols::parse(string).to_a.must_equal result
    end
  end

  it "should sum colored mana" do
    { "{W}{R}{G}" => 3,
      "{W}{U}" => 2
    }.each do |(string, result)|
      ManaSymbols::parse(string).cost.must_equal result
    end
  end

  it "should sum colored mana and colorless" do
    { "{W}{R}{6}" => 8,
      "{W}{U}{2}" => 4
    }.each do |(string, result)|
      ManaSymbols::parse(string).cost.must_equal result
    end
  end

  it "should consider {X} as 3 colorless mana" do
    { "{W}{R}{X}" => 5,
      "{W}{2}{X}" => 6
    }.each do |(string, result)|
      ManaSymbols::parse(string).cost.must_equal result
    end
  end
end
