# frozen_string_literal: true
require_relative 'combat_element'

module Irrgarten
  class Weapon < CombatElement
    def initialize(p,u)
      super(p,u)
    end

    public
    def attack
      produce_effect
    end

    def to_s
      "W[#{super}]"
    end

    def discard
      super
    end

    def uses
      super
    end

    def power
      effect
    end

  end

end
