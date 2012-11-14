require_relative 'spec_helper'

describe MagicCards::Card do
  it "should parse the name of some cards" do
    CARDS.keys.must_include "Angel of Serenity"
    CARDS.keys.must_include "Jace Beleren"
  end
  it "should decode ' correctly" do
    CARDS.keys.must_include "Jace's Erasure"
  end

  it "should find the correct type(s)" do
    CARDS["Jace Beleren"].type.must_equal %w(Planeswalker)
    CARDS["Dryad Arbor"].type.must_equal %w(Land Creature)
    CARDS["Heartwood Dryad"].type.must_equal %w(Creature)
    CARDS["Cancel"].type.must_equal %w(Instant)
    CARDS["Hammer of Ruin"].type.must_equal %w(Artifact)
    CARDS["Volcanic Hammer"].type.must_equal %w(Sorcery)
    CARDS["Karn, Silver Golem"].type.must_equal %w(Artifact Creature)
    CARDS["Obsidian Battle-Axe"].type.must_equal %w(Tribal Artifact)
  end

  it "should find the correct subtype(s)" do
    CARDS["Holy Strength"].subtype.must_equal %w(Aura)
    CARDS["Aura Shards"].subtype.must_equal %w()
    CARDS["Strength of Cedars"].subtype.must_equal %w(Arcane)
    CARDS["Silverblade Paladin"].subtype.must_equal %w(Human Knight)
    CARDS["Darksteel Axe"].subtype.must_equal %w(Equipment)
    CARDS["Obsidian Battle-Axe"].subtype.must_equal %w(Warrior Equipment)
  end

  it "should find the correct supertype(s)" do
    CARDS["Kiki-Jiki, Mirror Breaker"].supertype.must_equal %w(Legendary)
  end

  it "should find power/toughness" do
    CARDS["Kiki-Jiki, Mirror Breaker"].power.must_equal 2
    CARDS["Kiki-Jiki, Mirror Breaker"].toughness.must_equal 2
    CARDS["Blitz Hellion"].power.must_equal 7
    CARDS["Blitz Hellion"].toughness.must_equal 7
  end

  describe "should extract rules" do
    it "without explanations of keywords" do
      CARDS["Argothian Swine"].rules.to_a.must_equal [
                                                      "Trample"
                                                     ]
      CARDS["Archweaver"].rules.to_a.must_equal [
                                                 "Reach",
                                                 "Trample"
                                                ]
    end

    it "should group them by no" do
      CARDS["Archweaver"].rules.by_no.must_equal [["Reach", "Trample"]]
      CARDS["Armada Wurm"].rules.by_no.must_equal [["Trample"], ["When Armada Wurm enters the battlefield, put a 5/5 green Wurm creature token with trample onto the battlefield."]]
    end

    it "should return a halfway readable string" do
      CARDS["Bogardan Lancer"].rules.to_s.must_equal "Bloodthirst 1\nFlanking"
      CARDS["Assault Zeppelid"].rules.to_s.must_equal "Flying, Trample"
    end

  end
end
