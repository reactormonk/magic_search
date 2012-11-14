# encoding: utf-8
#
require 'sinatra/base'
require 'picky'
require 'nokogiri'
require 'magic_cards'
require File.expand_path '../logging', __FILE__

class CardSearch < Sinatra::Application

  # We do this so we don't have to type
  # Picky:: in front of everything.
  #
  include Picky

  # Data source.
  #
  class Cards
    def initialize
      @cards = MagicCards::populate
      @cards.each do |card|
        # delete the card's name from the rules index
        card.rules.each {|e| e.gsub!(card.name, "") }        
      end
    end

    def each(&block)
      @cards.each(&block)
    end

  end

  # Define an index.
  #
  cards_index = Index.new :cards do
    source   { Cards.new }
    key_format :to_s
    indexing removes_characters: /[^a-z0-9\s\/\-\_\:\"\&\.]/i,
             stopwords:          /\b(and|the|of|it|in|for)\b/i,
             splits_text_on:     /[\s\/\-\_\:\"\&\.]/
    category :name,
             similarity: Similarity::DoubleMetaphone.new(3),
             partial: Partial::Substring.new(from: 1) # Default is from: -3.
    category :rules
    category :supertype, partial: Partial::Substring.new(from: 1)
    category :type, partial: Partial::Substring.new(from: 1)
    category :subtype, partial: Partial::Substring.new(from: 1)
    category :power, partial: Partial::None.new
    category :toughness, partial: Partial::None.new
    category :editions
    category :multi
  end

  # Index and load on USR1 signal.
  #
  Signal.trap('USR1') do
    cards_index.reindex # kill -USR1 <pid>
  end

  # Define a search over the cards index.
  #
  cards = Search.new cards_index do
    searching substitutes_characters_with: CharacterSubstituters::WestEuropean.new, # Normalizes special user input, Ä -> Ae, ñ -> n etc.
              removes_characters: /[^\p{L}\p{N}\s\/\-\_\&\.\"\~\*\:\,]/i, # Picky needs control chars *"~:, to pass through.
              stopwords:          /\b(and|the|of|it|in|for)\b/i,
              splits_text_on:     /[\s\/\-\&]+/
    boost [:type] => 2,
          [:supertype] => 2,
          [:subtype] => 1,
          [:supertype, :type] => 3,
          [:type, :subtype] => 3,
          [:supertype, :subtype] => 3
  end

  # Route /cards to the cards search and log when searching.
  #
  get '/cards' do
    results = cards.search params[:query], params[:ids] || 20, params[:offset] || 0
    Picky.logger.info results
    results.to_json
  end

end
