require_relative "spec_helper.rb"
require 'nokogiri'

def normalize(html)
  Nokogiri::HTML(html).to_s
end

describe ManaSymbols do
  ManaSymbols.image_location = "/foo/bar"
  it "should return them as img tags" do
    normalize(ManaSymbols::parse("{R}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R.svg' alt='R'/>")
    normalize(ManaSymbols::parse("{R}{W}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R.svg' alt='R'/><img class='mana-symbol' src='/foo/bar/W.svg' alt='W'/>")
    normalize(ManaSymbols::parse("{2}{W}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/2.svg' alt='2'/><img class='mana-symbol' src='/foo/bar/W.svg' alt='W'/>")
  end
  it "should return them as img tags" do
    normalize(ManaSymbols::parse("{R/P}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R-P.svg' alt='R/P'/>")
    normalize(ManaSymbols::parse("{R/W}{U/B}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R-W.svg' alt='R/W'/><img class='mana-symbol' src='/foo/bar/U-B.svg' alt='U/B'/>")
  end

  it "should also work for strings" do
    normalize(ManaSymbols::parse_string("{B}, Remove a -1/-1 counter from Carnifex Demon: Put a -1/-1 counter on each other creature.").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/B.svg' alt='B'/>, Remove a -1/-1 counter from Carnifex Demon: Put a -1/-1 counter on each other creature.")
  end
end
