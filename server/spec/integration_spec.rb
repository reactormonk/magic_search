# coding: utf-8
#
require 'spec_helper'
require 'picky-client/spec'
require 'pry'

describe 'Integration Tests' do

  before(:all) do
    Picky::Indexes.index
    Picky::Indexes.load
  end

  let(:cards) { cards = Picky::TestClient.new(CardSearch, :path => '/cards')
    def cards.search_for(string) search(string)[:allocations][0][4] end
  cards }

  # Testing a count of results.
  #
  it { cards.search('life demon').total.should > 1 }

  # Testing a specific order of result ids.
  #
  #it { cards.search('alan').ids.should == [449, 259, 307] }

  # Testing an order of result categories.
  #
  it { cards.search('life').should have_categories(['rules'], ['name']) }
  it { cards.search('life demon').should have_categories(%w(rules subtype), %w(rules name), %w(rules rules)) }
  it { cards.search_for('life demon').should include "Soulcage Fiend" }

  it { cards.search_for('subtype:jace').size.should > 1 }
  it { cards.search_for('blue plainswalker').size.should include "Jace Beleren" }
  it { cards.search('memory').should have_categories(['name']) }
  it { cards.search_for('Arm with').should include('Arm with Æther') }
end
