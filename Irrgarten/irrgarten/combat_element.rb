# frozen_string_literal: true

module Irrgarten
  class CombatElement
    def initialize(effect, uses)
      @effect = effect
      @uses = uses
    end

    def discard
      Dice.discard_element(@uses)
    end

    def to_s
      "#{@effect}, #{@uses}"
    end

    def effect
      @effect
    end

    def uses
      @uses
    end

    protected def set_uses(uses)
      @uses = uses
    end

    def produce_effect
      result = 0
      if @uses > 0
        result = @effect
        @uses -= 1
      end
      result
    end

  end
end

