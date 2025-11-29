# frozen_string_literal: true
require_relative 'labyrinth_character'
module Irrgarten
  class Player < LabyrinthCharacter
    @@MAX_WEAPONS = 2
    @@MAX_SHIELDS = 3
    @@INITIAL_HEALTH = 10
    @@HIT2LOSE = 3


    def initialize(number, intelligence, strength, health)
      super("Player# #{number}", intelligence, strength, @@INITIAL_HEALTH)
      @consecutive_hits = 0

      @weapons = []
      @shields = []

      @weapons.push(new_weapon)
      @shields.push(new_shield)
    end
    def weapons
      @weapons
    end
    def shields
      @shields
    end
    def consecutive_hits
      @consecutive_hits
    end
    def self.copy(player)
      super(player)
      @number = player.number
      @consecutive_hits = player.consecutive_hits

      set_health(player.health)
      set_pos(player.row,player.col)

      @weapons.clear
      @shields.clear


      for w in player.weapons
        @weapons.push(w)
      end

      for s in player.shields
        @shields.push(s)
      end

    end
    def resurrect
      @consecutive_hits = 0
      @health = @@INITIAL_HEALTH
    end

    def row
      @row
    end

    def col
      @col
    end

    def number
      @number
    end

    def set_pos(row, col)
      @row = row
      @col = col
    end

    def dead
      super.dead
    end

    def attack
      @strength + sum_weapons
    end

    def to_s
      string = super.to_s

              string += "\n\nWeapons: \n"
              for w in @weapons do
                string += "#{w}\n"
              end

              string += "\nShields: \n"
              for s in @shields do
                string += "#{s}\n"
              end

      string
    end

    private def receive_weapons(weapon)
      i = @weapons.size - 1

      if @weapons.length > 0
        while i >= 0
          weapon_i = @weapons[i]

          if weapon_i.discard
            @weapons.delete_at(i)
          end

          i -= 1
        end
      end

      if @weapons.size < @@MAX_WEAPONS
        @weapons.push(weapon)
      end
    end

    private def receive_shields(shield)
      i = @shields.size - 1

      if @shields.length > 0
        while i >= 0
          shield_i = @shields[i]

          if shield_i.discard
            @shields.delete_at(i)
          end

          i -= 1
        end
      end

      if @shields.size < @@MAX_SHIELDS
        @shields.push(shield)
      end
    end

    private def new_shield
      Shield.new(Dice.shield_power, Dice.use_left)
    end

    private def new_weapon
      Weapon.new(Dice.weapon_power, Dice.use_left)
    end

    protected def sum_weapons
      sum = 0

      for weapon in @weapons do
        sum += weapon.attack
      end

      sum
    end

    protected def sum_shields
      sum = 0

      for shield in @shields do
        sum += shield.protect
      end

      sum
    end

    protected def defensive_energy
      @intelligence + sum_shields
    end

    private def manage_hit(received_attack)
      defense = defensive_energy
      lose = false

      if defense < received_attack
        got_wounded
        inc_consecutive_hits
      else
        reset_hit
      end

      if @consecutive_hits == @@HIT2LOSE || dead
        lose = true
      end

      lose
    end

    private def reset_hit
      @consecutive_hits = 0
    end

    private def got_wounded
      @health -= 1
    end

    private def inc_consecutive_hits
      @consecutive_hits += 1
    end

    def receive_reward
      w_reward = Dice.weapons_reward
      s_reward = Dice.shield_reward

      w_reward.times do
        wnew = new_weapon
        receive_weapons(wnew)
      end

      s_reward.times do
        snew = new_shield
        receive_shields(snew)
      end
      extra_health = Dice.health_reward
      @health += extra_health
    end

    def defend(received_attack)
      manage_hit(received_attack)
    end

    def move(direction, valid_moves)
      result = direction

      if (valid_moves.size > 0) &&  !valid_moves.include?(direction)
        first_element = valid_moves[0]
        result = first_element
      end

      result
    end
  end
end

