# frozen_string_literal: true

module Irrgarten
  class GameState
    def initialize(l, p, m, c, w, log)
      @labyrinth = l
      @players = p
      @monsters = m
      @current_player = c
      @winner = w
      @log = log
    end

    def labyrinth
      @labyrinth
    end

    def players
      string = "[\n"
      first = true
      for player in @players do
        if !first
          string += ", \n"
        end
        string += player.to_s
        first = false
      end
      string += "\n]"
      string
    end

    def monsters
      string = "[\n"
      first = true
      for monster in @monsters do
        if !first
          string += ", \n"
        end
        string += monster.to_s
        first = false
      end
      string += "\n]"
      string
    end

    def current_player
      @current_player
    end

    def winner
      @winner
    end

    def log
      @log
    end

  end

end

