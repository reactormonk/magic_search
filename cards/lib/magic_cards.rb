require 'nokogiri'

module MagicCards
  class Rules
    def initialize(xml)
      @xml = xml
    end

    def rules
      @xml.xpath('./rule')
    end

    def to_a
      rules.map(&:text)
    end

    def by_no
      rules.group_by {|e| e['no']}.map {|_,e| e.map(&:text)}
    end

    def to_s
      by_no.map {|e| e.join(", ")}.join("\n")
    end
  end

  class Card < Struct.new(*%w(id name supertype type subtype rules editions multi).map(&:to_sym))
  end

  def self.populate(klass = Card)
    file_name = File.expand_path "../data/cards.xml", File.dirname(__FILE__)
    ::Nokogiri::XML(File.read(file_name)).xpath('//card').map do |xml|
      name = xml.xpath('.//name').text
      klass.new.tap do |card|
        card.id = name.dup # picky is evil here, so we need a duped name
        card.name = name
        card.type = xml.xpath('.//type[@type="card"]').map(&:text)
        card.subtype = xml.xpath('.//type[@type="sub"]').map(&:text)
        card.supertype = xml.xpath('.//type[@type="super"]').map(&:text)
        card.rules = Rules.new(xml.xpath('.//rulelist'))
      end
    end
  end
end
