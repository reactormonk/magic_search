require 'nokogiri'
require 'tilt'
require 'haml'
require 'magic_cards'

module MagicCards
  cards = populate
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

    def type
      @data.type
    end

    def subtype
      @data.subtype
    end

    def supertype
      @data.supertype
    end

    def name
      @data.name
    end

    def rules
      @data.rules
    end

    def to_html
      Template.render(self)
    end
  end
end
