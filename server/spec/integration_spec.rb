# coding: utf-8
#
require 'spec_helper'
require 'picky-client/spec'

describe 'Integration Tests' do

  before(:all) do
    Picky::Indexes.index
    Picky::Indexes.load
  end

  let(:cards) { Picky::TestClient.new(CardSearch, :path => '/cards') }

  # Testing a count of results.
  #
  it { cards.search('life demon').total.should == 19 }

  # Testing a specific order of result ids.
  #
  #it { cards.search('alan').ids.should == [449, 259, 307] }

  # Testing an order of result categories.
  #
  it { cards.search('life').should have_categories(['rules'], ['name']) }
  it { cards.search('life demon').should have_categories(%w(rules subtype), %w(rules name), %w(rules rules)) }
  it { cards.search('life demon')[:allocations][0][4].include? "Demon of Death's Gate" }

end
