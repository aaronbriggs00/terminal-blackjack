require "./deck.rb"
require "./players.rb"
require "tty-prompt"

class Blackjack
  attr_accessor :dealer, :p1, :p2, :p3, :deck, :end
  def initialize(n)
    @dealer = Dealer.new
    @dealer_card = "unflipped"
    @end = false
    @p1 = Player.new(1)
    @p2 = Player.new(2)
    @p3 = Player.new(3)
    @deck = Deck.new(n)
  end

  def table 
    [ @p1,
      @p2,
      @p3 ]
  end

  def deal
    table.each do |player|
      player.hand.push(deck.draw)
      player.hand.push(deck.draw)
    end
    dealer.hand.push(deck.draw)
    dealer.hand.push(deck.draw)
    dealer.hand[0].flip
  end

  def round_end_check
    table_actions = []
    table.each do |player|
      if player.action == "stay" || player.evaluate_hand == "bust"
      else
        table_actions.push(1)
      end
    end
    if table_actions == []
      return true
    end
    false
  end

  def cash_out
    table.each do |player|
      if player.evaluate_hand != "bust"
        if (21 - player.evaluate_hand) < (21 - dealer.evaluate_hand).abs
          player.money += player.bet
        elsif (21 - player.evaluate_hand) == (21 - dealer.evaluate_hand).abs
          #do nothing
        else
          player.money -= player.bet
        end
      else
        player.money -= player.bet
      end
    end
  end

  def reset
    dealer.hand = []
    dealer_card = "unflipped"
    table.each do |player|
      player.bet = 0
      player.action = ""
      player.hand = []
    end
  end

  def round
    deal
    update
    table.each do |player|
      player.place_bet
    end
    update
    until round_end_check
      table.each do |player|
        if player.evaluate_hand != "bust" && player.action != "stay"
          player.determine_action
          if player.action == "hit"
            player.hand.push(deck.draw)
          end
        end
        update
      end
    end
    @dealer_card = "flipped"
    dealer.determine_action
    if dealer.action == "hit"
      dealer.hand.push(deck.draw)
    end
    dealer.hand[0].flip
    update
    cash_out
    update
    puts "input any key to start next round or type exit to end the game"
    input = gets.chomp
    if input == "exit"
      @end = true
    end
  end

  #terminal visuals
  def draw_hand(hand)
    # generates card group visuals
    result = Array.new(17, " "*20)
    j = 0
    hand.each do |card|
      result.map!.with_index do |row, i|
        if i >= j && i < j+card.image.length
          row[0..j] + card.image[i-j]
        else
          row
        end
      end
      j += 2
    end
    result.map! do |row|
      "%-22s" % "#{row}"
    end
    result
  end

  def draw
    #formats game view
    puts "    RUBY BLACK JACK"
    if @dealer_card == "flipped"
      puts " " * 42 + "DEALER" + " " * 9 + "Hand : #{dealer.evaluate_hand}"
    else
      puts " " * 42 + "DEALER"
    end
    dealer_cards = Array.new(9, " "*41)
    dealer.hand.each_with_index do |card, i|
      dealer_cards.map!.with_index do |row, j|
        row + dealer.hand[i].image[j]
      end
    end
    puts dealer_cards 
    puts "=" * 123
    puts "=" * 123
    puts " Player 2" + " " * 31 + "! Player 1" + " " * 31 + "! Player 3"
    p1_visual = draw_hand(p1.hand)
    p2_visual = draw_hand(p2.hand)
    p3_visual = draw_hand(p3.hand)
    17.times do |i|
      puts " "*6 + p2_visual[i] + " "*12 + "!" + " "*6 + p1_visual[i] + " "*12 + "!" + " "*6  + p3_visual[i]
    end 
    #board data *the WETTEST garbage
    puts " Hand : " + "%-4s" % "#{p2.evaluate_hand}" + " " * 15 + "Money : " + "%-4s" % "#{p2.money}" + " !" +" Hand : " + "%-4s" % "#{p1.evaluate_hand}" + " " * 15 + "Money : " + "%-4s" % "#{p1.money}"+ " !" +" Hand : " + "%-4s" % "#{p3.evaluate_hand}" + " " * 15 + "Money : " +"%-6s" % "#{p3.money}"
    puts " Action : " + "%-4s" % "#{p2.action}" + " " * 15 + "Bet : ""%-4s" % "#{p2.bet}" + " !" + " Action : " + "%-4s" % "#{p1.action}" + " " * 15 + "Bet : ""%-4s" % "#{p1.bet}" + " !" + " Action : " + "%-4s" % "#{p3.action}" + " " * 15 + "Bet : ""%-4s" % "#{p3.bet}" + "  "
    puts "=" * 123
    puts "=" * 123
  end

  def update
    system "clear"
    draw
    sleep(0.2)
  end
end

