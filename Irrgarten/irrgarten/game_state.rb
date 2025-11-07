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
      @labyrinth.to_s
    end

    def players
      string = ""
      for player in @players
        string += player.to_s
      end
      string
    end

    def monsters
      string = ""
      for monster in @monster
        string += monster.to_s
      end
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

