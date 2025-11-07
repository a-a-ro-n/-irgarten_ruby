# frozen_string_literal: true
require_relative 'weapon'
require_relative 'shield'
require_relative 'orientation'
require_relative 'directions'
require_relative 'game_state'
require_relative 'dice'
require_relative 'game_character'

module Irgarten
  class TestP1
    def self.main
      puts "--------------------------------------------------"
      puts "      INICIO DE PRUEBAS PARA LA PRÁCTICA 1        "
      puts "--------------------------------------------------"

      # -- Instancias a crear --
      weapon0 = Irrgarten::Weapon.new(8, 5)
      weapon1 = Irrgarten::Weapon.new(4, 10)

      shield0 = Irrgarten::Shield.new(5, 4)
      shield1 = Irrgarten::Shield.new(3, 5)

      # -- Prueba de Enumerados --
      player0 = GameCharacter::PLAYER
      monster0 = GameCharacter::MONSTER

      puts "\n\n --- ENUMERADOS ---"
      puts " Personaje: #{player0}"
      puts " Monstruo: #{monster0}"
      puts " Dirección de movimiento: #{Directions::UP}"
      puts " Orientación del tablero: #{Orientation::HORIZONTAL}"


      # -- Prueba Weapons y Shield --
      puts "\n\n --- WEAPONS / SHIELD ---"

      # Weapons
      puts " -- W0 inicial: #{weapon0.to_s}" # W[8.0, 5]

      2.times do |i|
        weapon0.attack # ataque
        numero = i + 1
        puts " W0 ataque #{numero}: #{weapon0.to_s}"
      end

      puts " W0.discard(): #{weapon0.discard}" # Descarte??

      # Weapon agotado
      puts "\n\n -- Probando Weapon agotado (W1: #{weapon1.to_s})"

      uses_weapon1 = weapon1.uses # Acceso al atributo con attr_reader

      uses_weapon1.times do
        weapon1.attack # ataque
        puts " #{weapon1.to_s}" # visualizacion del desgaste del arma
      end

      puts " W1 Uses: #{weapon1.to_s}" # Uses debe ser 0
      puts " W1 intento de attack (debe ser 0.0): #{weapon1.attack}"


      # Prueba de Shield
      puts "\n -- S0 inicial: #{shield0.to_s}" # S[5.0, 4]

      2.times do |i|
        shield0.protect # proteje
        numero = i + 1
        puts " S0 defensa #{numero}: #{shield0.to_s}"
      end

      puts " S0.discard(): #{shield0.discard}" # Descarte??

      # Shield agotado
      puts "\n\n -- Probando Shield agotado (S1: #{shield1.to_s})"

      uses_shield1 = shield1.uses # Acceso al atributo con attr_reader

      uses_shield1.times do
        shield1.protect # proteje
        puts " #{shield1.to_s}" # visualizacion del desgaste del escudo
      end

      puts " S1 Uses: #{shield1.to_s}" # Uses debe ser 0
      puts " S1 intento de protect (debe ser 0.0): #{shield1.protect}"


      # -- Prueba GameState --
      gameState = Irrgarten::GameState.new("1", "3", "2", 2, false, "Comienzo de partida")

      puts "\n\n --- GAMESTATE ---"
      puts " Labyrinth: #{gameState.labyrinth}"
      puts " Players: #{gameState.players}"
      puts " Current Player: #{gameState.current_player}"
      puts " Winner: #{gameState.winner}"


      # -- Prueba Dice --
      puts "\n\n --- DICE (100 ITERACIONES) ---"

      totalPruebas = 100

      # resurrectPlayer()
      resurrecciones = 0

      totalPruebas.times do
        if Irrgarten::Dice.resurrect_player # pob. del 30% aproximadamentes
          resurrecciones += 1
        end
      end

      probResurrect = resurrecciones.to_f / totalPruebas
      puts "\n resurrectPlayer (percentage): #{(probResurrect.to_f)}"

      # randomPos() y whoStarts()
      maxPos = 10
      maxPlayers = 4

      puts " randomPos: #{Irrgarten::Dice.random_pos(maxPos)}"
      puts " whoStarts: #{Irrgarten::Dice.who_starts(maxPlayers)}"

      # rewards
      maxW = 0
      maxS = 0

      totalPruebas.times do
        maxW = [maxW, Irrgarten::Dice.weapons_reward].max
        maxS = [maxS, Irrgarten::Dice.shield_reward].max
      end

      puts " weaponsReward: #{maxW}"
      puts " sheildReward: #{maxS}"

      # discardElement
      puts " discardElement(0): #{Irrgarten::Dice.discard_element(0)}" # usesLeft = 0 (debería devolver true con alta probabilidad)
      puts " discardElement(5): #{Irrgarten::Dice.discard_element(5)}" # usesLeft = 5 (debería devolver false con alta probabilidad)

      puts "\n\n--------------------------------------------------"
      puts "                 FIN DE PRUEBAS                   "
      puts "--------------------------------------------------"
    end
  end

  TestP1.main
end
