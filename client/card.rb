require 'nokogiri'
require 'tilt'
require 'haml'
require 'magic_cards'

module MagicCards
  print "Loading cards... "
  cards = populate
  puts "Done."
  CARD_MAPPING = Hash[cards.map(&:name).zip(cards)]
  class Card

    # Find uses a lookup table.
    #
    def self.find ids, _ = {}
      ids.map { |id| MagicCards::CARD_MAPPING[id] }
    end

  end
end

module Presenter
  class Card
    Template = Tilt.new('views/card.haml')
    def initialize(data)
      @data = data
    end

    %w(type subtype supertype name power toughness).each do |name|
      define_method(name) do
        @data.send(name)
      end
    end

    def manacost?
      !! @data.cost
    end

    def manacost
      @data.cost.to_html
    end

    def rules
      @data.rules.by_no.map do |rules|
        rules.map {|rule| ::ManaSymbols.parse_string(rule).to_html }.flatten
      end
    end

    def to_html
      Template.render(self)
    end
  end
end

ManaSymbols::image_location = "/images"
