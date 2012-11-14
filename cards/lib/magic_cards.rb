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

  class Card
    def self.parse(xml)
      card = new(xml)
      if sub_xml = xml.xpath('./multi').first
        card.other_card = sub_card = new(sub_xml)
        sub_card.other_card = card
        sub_card.multi = card.multi = sub_xml['type']
      end
      [card, sub_card].compact
    end

    attr_reader *%w(id name supertype type subtype rules editions power toughness).map(&:to_sym)
    attr_accessor :other_card, :multi
    def initialize(xml_node)
      @name = xml_node.xpath('./name').text
      @id = @name.dup # picky is evil here, so we need a duped name
      @type = xml_node.xpath('./typelist/type[@type="card"]').map(&:text)
      @subtype = xml_node.xpath('./typelist/type[@type="sub"]').map(&:text)
      @supertype = xml_node.xpath('./typelist/type[@type="super"]').map(&:text)
      @power = xml_node.xpath('./pow').text.to_i
      @toughness = xml_node.xpath('./tgh').text.to_i
      @rules = Rules.new(xml_node.xpath('./rulelist'))
    end
  end

  def self.populate
    file_name = File.expand_path "../data/cards.xml", File.dirname(__FILE__)
    ::Nokogiri::XML(File.read(file_name)).xpath('//card').flat_map do |xml|
      Card.parse(xml)
    end
  end
end
