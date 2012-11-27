require 'mana_symbols/basic'
require 'mana_symbols/advanced'
module ManaSymbols
  class << self
    attr_accessor :image_location
  end

  class Basic
    def to_html
      "<img class='mana-symbol' src='#{ManaSymbols.image_location}/#{mana_name.sub("/", "-")}.svg' alt='#{mana_name}'/>"
    end
  end

  class ManaCost
    def to_html
      symbols.map(&:to_html).join("")
    end
  end

  class StringParser
    def to_html
      @array.map {|str| str.respond_to?(:to_html) ? str.to_html : str.to_s}.join("")
    end
  end
end
