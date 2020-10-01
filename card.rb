class Card
  attr_accessor :value, :rank, :suit, :cut
  def initialize(rank, suit)
    face_cards = {A: 11, K: 10, J: 10, Q: 10}
    @rank = rank
    @value = face_cards[rank] || rank
    @suit = suit
    @flipped = false
    @real = true
    @cut = false
  end

  def image
    icons = { S: "♠", C: "♣", H: "♥", D: "♦" }
    if @flipped == false
      image = [
        "┌───────────┐",
        "|%-11s|" % "#{rank}",
        "|%-11s|" % "",
        "|%-11s|" % "",
        "|"+"#{icons[suit.to_sym]}".center(11, " ")+"|",
        "|%-11s|" % "",
        "|%-11s|" % "",
        "|%11s|" % "#{rank}",
        "└───────────┘"
      ]
    else
      image = [
        "┌───────────┐",
        "│░░░░░░░░░░░│",
        "│░░░░░░░░░░░│",
        "│░RUBY░░░░░░│",
        "│░░░BLACK░░░│",
        "│░░░░░░JACK░│",
        "│░░░░░░░░░░░│",
        "│░░░░░░░░░░░│",
        "└───────────┘"
      ]
    end 
  end

  def flip
    if @flipped == true
      @flipped = false
    else
      @flipped = true
    end
  end
end
