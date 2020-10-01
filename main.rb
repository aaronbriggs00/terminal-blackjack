require "./game.rb"
require "tty-prompt"

system "clear"
game = Blackjack.new(2)
game.deck.insert_cut
until game.deck.final || game.end
  game.round
  game.reset
end

