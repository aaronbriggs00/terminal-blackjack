require "./card.rb"

class Deck
  attr_reader :cards, :final
  def initialize(n)
    @shoe_size = n
    @final = false
    @cards = []
    suits = [:S, :H, :C, :D]
    ranks = [2,3,4,5,6,7,8,9,10,:J,:Q,:K,:A]
    n.times do
      suits.each do |suit|
        ranks.each do |rank|
          @cards.push(Card.new(rank, suit))
        end
      end
    end
  end

  def insert_cut
    @cards.shuffle!
    i = rand((@cards.length/2)-10..(@cards.length/2)+10)
    @cards[i].cut = true
  end

  def draw
    if @cards[-1].cut
      @final = true
    end
    @cards.shift
  end

  def return(card)
    @cards.push(card)
  end
end