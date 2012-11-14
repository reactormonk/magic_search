require_relative 'spec_helper'
describe MagicCards::Card do
  it "should split multi-cards" do
    CARDS["Life"].type.must_equal %w(Sorcery)
    CARDS["Death"].type.must_equal %w(Sorcery)
    CARDS["Life"].other_card.must_equal CARDS["Death"]
    CARDS["Life"].multi.must_equal "double"
    CARDS["Life"].rules.to_a.must_equal ["All lands you control become 1/1 creatures until end of turn. They're still lands."]
    CARDS["Death"].rules.to_a.must_equal ["Return target creature card from your graveyard to the battlefield. You lose life equal to its converted mana cost."]
  end

  it "should not add further information to normal cards" do
    CARDS["Jace Beleren"].other_card.must_equal nil
  end
end
