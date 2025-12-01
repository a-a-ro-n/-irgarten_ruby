# frozen_string_literal: true
require_relative 'combat_element'
module Irrgarten
  class Shield < CombatElement
    def initialize(p,u)
      super(p,u)
    end

    def uses
      super
    end

    def power
      effect
    end

    def protect
      produce_effect
    end

    def to_s
      "S[#{super}]"
    end

    def discard
      super
    end

  end
end

