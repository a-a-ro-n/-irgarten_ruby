# frozen_string_literal: true
module Irrgarten
  class LabyrinthCharacter
     def initialize (name,intelligence,strength,health)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = health
    end
    def self.copy(other)
      new(other.name,other.intelligence,other.strength, other.health)
      @row = other.instance_variable_get(:@row)
      @col = other.instance_variable_get(:@col)
    end

     def dead
       @health <= 0
     end

     def set_pos(row,col)
       @row = row
       @col = col
     end

     def col
       @col
     end

     def row
       @row
     end

     protected def intelligence
       @intelligence
     end

     protected def strength
       @strength
     end

     protected def health
       @health
     end

     protected def set_health(health)
       @health = health
     end

     def got_wounded

     end

     def attack

     end

     def defend(attack)

     end

     def to_s
       "\n\nNombre: #{@name}\nPosicion: (#{@row},#{@col})
       \nIntelligence: #{@intelligence}\nStrength: #{@strength}
       \nHealth: #{@health}\n"
     end
  end
end

