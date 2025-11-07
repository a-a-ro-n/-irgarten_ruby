# frozen_string_literal: true

module Irrgarten
  class Dice
    MAX_USES = 5
    MAX_INTELLIGENCE = 10.0
    MAX_STRENGTH = 10.0
    RESURRECT_PROB = 0.3
    WEAPONS_REWARD = 2
    SHIELDS_REWARD = 3
    HEALTH_REWARD = 5
    MAX_ATTACK = 3
    MAX_SHIELD = 2

    @random = Random.new

    def self.random_pos(max)
      @random.rand(max)
    end

    def self.who_starts(players)
      @random.rand(players)
    end

    def self.random_intelligence
      @random.rand(MAX_INTELLIGENCE)
    end

    def self.random_strength
      @random.rand(MAX_STRENGTH)
    end

    def self.resurrect_player
      @random.rand < RESURRECT_PROB
    end

    def self.weapons_reward
      @random.rand(WEAPONS_REWARD) + 1
    end

    def self.shield_reward
      @random.rand(SHIELDS_REWARD) + 1
    end

    def self.health_reward
      @random.rand(HEALTH_REWARD) + 1
    end

    def self.weapon_power
      (@random.rand(MAX_ATTACK) + 1).to_f
    end

    def self.shield_power
      (@random.rand(MAX_SHIELD) + 1).to_f
    end

    def self.use_left
      @random.rand(MAX_USES) + 1
    end

    def self.intensity(competence)
      @random.rand(competence).to_f
    end

    def self.discard_element(uses)
      prob_no_discard = (uses.to_f / MAX_USES) * 10
      (rand(10).to_f + 1) > prob_no_discard
    end
  end
end

