require 'rubygems'
require 'bundler'
Bundler.require

# Load the "model".
#
require File.expand_path 'card', File.dirname(__FILE__)

set :haml, { :format => :html5 }

# Sets up two query instances.
#
CardsSearch = Picky::Client.new :host => 'localhost', :port => 8080, :path => '/cards'

set :static, true
set :public_folder, File.dirname(__FILE__)
set :views,  File.expand_path('views', File.dirname(__FILE__))

# Root, the search interface.
#
get '/' do
  @query = params[:q]

  haml :'/search'
end

# For full results, you get the ids from the picky server
# and then populate the result with models (rendered, even).
#
get '/search/full' do
  results = CardsSearch.search params[:query], :ids => params[:ids], :offset => params[:offset]
  results.extend Picky::Convenience
  results.populate_with MagicCards::Card do |card|
    Presenter::Card.new(card).to_html
  end

  #
  # Or use:
  #   results.populate_with Card
  #
  # Then:
  #   rendered_entries = results.entries.map do |card| (render each card here) end
  #

  ActiveSupport::JSON.encode results
end

# For live results, you'd actually go directly to the search server without taking the detour.
#
get '/search/live' do
  CardsSearch.search_unparsed params[:query], :offset => params[:offset]
end

helpers do

  def js(path)
    "<script src='javascripts/#{path}.js' type='text/javascript'></script>"
  end

end
