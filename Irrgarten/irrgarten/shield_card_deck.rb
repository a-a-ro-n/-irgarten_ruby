# frozen_string_literal: true

module Irrgarten
  class ShieldCardDeck < CardDeck
    @@CARDS = 3

    def initialize
    end
    protected def create_card
      Shield.new(Dice.shield_power, Dice.use_left)
    end

    protected def add_cards
      i = 0
      @@CARDS.times do
        super.add_card(create_card)
      end
    end
  end

end
