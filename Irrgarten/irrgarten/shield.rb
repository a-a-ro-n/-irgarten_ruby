# frozen_string_literal: true
require_relative 'dice'
module Irrgarten
  class Shield
    def initialize(p,u)
      @power = p
      @uses = u
    end

    def protect
      protection = 0
      if @uses > 0
        protection = @power
        @uses -= 1
      end
      protection
    end

    def to_s
      "S[#{@power.to_f}, #{@uses}]"
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

