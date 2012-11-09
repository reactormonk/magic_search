# encoding: utf-8
#
require 'sinatra/base'
require 'picky'
require 'nokogiri'
require File.expand_path '../logging', __FILE__

class CardSearch < Sinatra::Application

  # We do this so we don't have to type
  # Picky:: in front of everything.
  #
  include Picky

  # Data source.
  #
  class Cards
    class Card < Struct.new(*%w(id name supertype type subtype rules editions multi).map(&:to_sym))
    end

    def initialize
      @cards = []
      file_name = File.expand_path "data/#{PICKY_ENVIRONMENT}/cards.xml", File.dirname(__FILE__)
      ::Nokogiri::XML(File.read(file_name)).xpath('//card').each do |xml|
        name = xml.xpath('.//name').text
        @cards.push(Card.new.tap do |card|
          card.id = name.dup
          card.name = name
          card.type = xml.xpath('.//type[@type="card"]').map(&:text)
          card.subtype = xml.xpath('.//type[@type="sub"]').map(&:text)
          card.supertype = xml.xpath('.//type[@type="super"]').map(&:text)
          card.rules = xml.xpath('.//rule').map {|e| e.text.gsub(name, "") }
        end)
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
