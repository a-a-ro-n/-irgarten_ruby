# frozen_string_literal: true

module Irrgarten
  class CardDeck
    def initialize
      @card_deck = []
      add_cards
    end
    def create_card()

    end

    def add_cards

    end

    protected def add_card(card)
      @card_deck << card
    end

    def next_card
      if @card_deck.empty?
        add_cards
        @card_deck.shuffle!
      end

      @card_deck.shift
    end

  end
end

