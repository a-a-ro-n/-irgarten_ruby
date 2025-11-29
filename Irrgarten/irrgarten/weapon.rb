# frozen_string_literal: true
require_relative 'dice'

module Irrgarten
  class Weapon < CombatElement
    def initialize(p,u)
      super(p,u)
    end

    public
    def attack
      super.produce_effect
    end

    def to_s
      "W[#{super.to_s}]"
    end

    def discard
      super.discard
    end

    def uses
      super.uses
    end

    def power
      super.effect
    end

  end

end
