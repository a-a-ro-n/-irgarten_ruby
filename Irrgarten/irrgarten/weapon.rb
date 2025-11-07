# frozen_string_literal: true
require_relative 'dice'

module Irrgarten
  class Weapon
    def initialize(p,u)
      @power = p
      @uses = u
    end

    public
    def attack
      damage = 0
      if @uses > 0
        damage = @power
        @uses -= 1
      end
      damage
    end

    def to_s
      "W[#{@power.to_f}, #{@uses}]"
    end

    def discard
      Irrgarten::Dice.discard_element(@uses)
    end

    def uses
      @uses
    end

    def power
      @power
    end

  end

end
