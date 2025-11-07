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
      @players
    end

    def monsters
      @monsters
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

