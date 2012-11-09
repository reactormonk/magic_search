require 'nokogiri'

class Card < Struct.new(*%w(id name supertype type subtype rules editions multi).map(&:to_sym))

  CARD_MAPPING = {}
  
  # Find uses a lookup table.
  #
  def self.find ids, _ = {}
    ids.map { |id| CARD_MAPPING[id] }
  end
  
  # "Rendering" ;)
  #
  # Note: This is just an example. Please do not render in the model.
  #
  def to_s
    "<li class='card'><h3>#{name}</h3><em>#{supertype.join(" ")} #{type.join(" ")} #{subtype.join(" ")}</em><p>#{rules.join("\n")}</p></li>"
  end
  
end

# Load the cards on startup.
#
file_name = File.expand_path "data/#{PICKY_ENVIRONMENT}/cards.xml", File.dirname(__FILE__)
Nokogiri::XML(File.read(file_name)).xpath('//card').each do |xml|
  name = xml.xpath('.//name').text
  Card::CARD_MAPPING[name] = Card.new.tap do |card|
    card.id = (card.name = name).dup
    card.type = xml.xpath('.//type[@type="card"]').map(&:text)
    card.subtype = xml.xpath('.//type[@type="sub"]').map(&:text)
    card.supertype = xml.xpath('.//type[@type="super"]').map(&:text)
    card.rules = xml.xpath('.//rule').map(&:text)
  end
end
