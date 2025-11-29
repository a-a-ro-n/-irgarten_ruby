# frozen_string_literal: true
require_relative 'player'
module Irrgarten
  class FuzzyPlayer < Player
    
    def initialize(player)
      super(player)
    end

    def move(direction, valid_moves)
      Dice.next_step(direction, valid_moves, @intelligence)
    end

    def attack
      sum_weapons + Dice.intensity(@strength)
    end

    protected def defensive_energy
      sum_shields + Dice.intensity(@intelligence)
    end

    def to_s
      "\nFuzzy #{super.to_s}"
    end
  end
end

