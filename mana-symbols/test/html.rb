require_relative "spec_helper.rb"
require 'nokogiri'

def normalize(html)
  Nokogiri::HTML(html).to_s
end

describe ManaSymbols do
  it "should return them as img tags" do
    ManaSymbols.image_location = "/foo/bar"
    normalize(ManaSymbols::parse("{R}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R.svg' alt='R'/>")
    normalize(ManaSymbols::parse("{R}{W}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R.svg' alt='R'/><img class='mana-symbol' src='/foo/bar/W.svg' alt='W'/>")
    normalize(ManaSymbols::parse("{2}{W}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/2.svg' alt='2'/><img class='mana-symbol' src='/foo/bar/W.svg' alt='W'/>")
  end
  it "should return them as img tags" do
    ManaSymbols.image_location = "/foo/bar"
    normalize(ManaSymbols::parse("{R/P}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R-P.svg' alt='R/P'/>")
    normalize(ManaSymbols::parse("{R/W}{U/B}").to_html).must_equal normalize("<img class='mana-symbol' src='/foo/bar/R-W.svg' alt='R/W'/><img class='mana-symbol' src='/foo/bar/U-B.svg' alt='U/B'/>")
  end
end
