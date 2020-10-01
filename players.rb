require "./deck.rb"
require "tty-prompt"


class Player
  attr_accessor :number, :human, :money, :hand, :bet, :action
  def initialize(n)
    @number = n
    @human = true if n == 1
    @money = 500
    @hand = []
    @bet = 0
    @action = ""
  end

  def ace_count
    @hand.map{|card|card.rank}.count(:A)
  end

  def evaluate_hand
    total = @hand.map{|card|card.value}.reduce(:+)
    aces = ace_count
    while total > 21 && aces > 0
      total -= 10
      aces -= 1
    end
    if total > 21
      total = "bust"
    end
    total
  end

  def place_bet
    if @human
      puts "enter your bet"
      input = gets.chomp.to_i
      @bet = input
    else
      @bet = rand(0..money/2)
    end
  end

  def determine_action
    if @human
      prompt = TTY::Prompt.new
      choices = {hit: "hit", stay: "stay"}
      @action = prompt.select("", choices)
    else
      if evaluate_hand >= 17
        @action = "stay"
      else
        @action = "hit"
      end
    end
  end
end

class Dealer
  attr_accessor :hand, :action
  def initialize
    @hand = []
    @action = ""
  end

  def determine_action
    if evaluate_hand >= 17
      @action = "stay"
    else
      @action = "hit"
    end
  end

  def ace_count
    @hand.map{|card|card.rank}.count(:A)
  end

  def evaluate_hand
    total = @hand.map{|card|card.value}.reduce(:+)
    aces = ace_count
    while total > 21 && aces > 0
      total -= 10
      aces -= 1
    end
    total
  end
end