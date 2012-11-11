require 'nokogiri'

module MagicCards
  class Card < Struct.new(*%w(id name supertype type subtype rules editions multi).map(&:to_sym))
  end

  def self.populate(klass = Card)
    file_name = File.expand_path "../data/cards.xml", File.dirname(__FILE__)
    ::Nokogiri::XML(File.read(file_name)).xpath('//card').map do |xml|
      name = xml.xpath('.//name').text
      klass.new.tap do |card|
        card.id = name.dup
        card.name = name
        card.type = xml.xpath('.//type[@type="card"]').map(&:text)
        card.subtype = xml.xpath('.//type[@type="sub"]').map(&:text)
        card.supertype = xml.xpath('.//type[@type="super"]').map(&:text)
        card.rules = xml.xpath('.//rule')
      end
    end
  end
end
