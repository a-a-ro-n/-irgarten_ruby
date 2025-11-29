# frozen_string_literal: true

module Irrgarten
  class WeaponCardDeck < CardDeck
    @@CARDS = 3
    def initialize
    end

    protected def create_card
      Weapon.new(Dice.weapon_power, Dice.use_left)
    end

    protected def add_cards
      @@CARDS.times do
        add_card(create_card)
      end
    end
  end
end

