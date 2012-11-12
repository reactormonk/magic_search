$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'magic_cards'
require 'minitest/spec'
require 'minitest/autorun'
require 'pry'

$stderr.write "Loading cards... "
cards = MagicCards::populate
$stderr.puts "Done."
CARDS = Hash[cards.map(&:name).zip cards]
