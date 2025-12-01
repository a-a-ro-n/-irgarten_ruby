# frozen_string_literal: true
require_relative 'labyrinth_character'
module Irrgarten
  class Monster < LabyrinthCharacter
    INITIAL_HEALTH = 5

    def initialize(name, intelligence, strength)
      super(name, intelligence, strength, INITIAL_HEALTH)
    end

    def dead
      super
    end

    def attack
      Dice.intensity(strength)
    end

    def set_pos(row, col)
      super
    end

    def to_s
      super
    end

    def got_wounded
      super
    end

    def defend(received_attack)
      is_dead = dead

      unless is_dead
        defensive_energy = Dice.intensity(@intelligence)

        if defensive_energy < received_attack
          got_wounded
          is_dead = dead
        end
      end

      is_dead
    end

  end

end

