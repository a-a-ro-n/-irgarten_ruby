# frozen_string_literal: true
require_relative 'combat_element'
module Irrgarten
  class Shield < CombatElement
    def initialize(p,u)
      super(p,u)
    end

    def uses
      super.uses
    end

    def power
      super.effect
    end

    def protect
      super.produce_effect
    end

    def to_s
      "S[#{super.to_s}]"
    end

    def discard
      super.discard
    end

  end
end

