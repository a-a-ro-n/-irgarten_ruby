# frozen_string_literal: true
module Irrgarten
  class Monster
    INITIAL_HEALTH = 5

    def initialize(name, intelligence, strenth)
      @name = name
      @intelligence = intelligence
      @strenth = strenth
      @health = INITIAL_HEALTH
    end

    def dead
      @health <= 0
    end

    def attack
      Irrgarten::Dice.intensity(@strenth)
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def to_s
      string = "Nombre: " + @name + "\nPosicion: (" + @row + "," + @col + ")\nIntelligence: " + @intelligence +
               "\nStrength: " + @strength + "\nHealth: " + @health
      string
    end

    def got_wounded
      @health -= 1
    end

    def defend(received_attack)
      id_dead = dead

      if !is_dead
        defensive_energy = Irrgarten::Dice.intensity(@intelligence)

        if defensive_energy < received_attack
          got_wounded
          is_dead = dead
        end
      end

      is_dead
    end

  end

end

