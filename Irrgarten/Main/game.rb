# frozen_string_literal: true

require_relative '../irrgarten/game'
require_relative '../UI/textUI'
require_relative '../controller/controller'
require_relative '../irrgarten/game_character'
require_relative '../irrgarten/orientation'
require_relative '../irrgarten/directions'
require_relative '../irrgarten/dice'
require_relative '../irrgarten/game_state'
require_relative '../irrgarten/shield'
require_relative '../irrgarten/player'
require_relative '../irrgarten/labyrinth'
require_relative '../irrgarten/monster'
require_relative '../irrgarten/weapon'

module Main
  class GAME
    def self.main
      players = 2
      game = Irrgarten::Game.new(players)
      view = UI::TextUI.new
      control = Control::Controller.new(game,view)
      control.play

      puts "\n*** ¡FIN DEL JUEGO! ***"
    end
  end

  GAME.main
end

