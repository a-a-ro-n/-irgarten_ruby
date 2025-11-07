# frozen_string_literal: true

module Irrgarten
  class Game
    @@MAX_ROUNDS = 10
    @@NROWS = 10
    @@NCOLS = 10
    def num_players
      @num_players
    end

    def num_monsters
      @num_monsters
    end

    def initialize(nplayers)
      @players = []
      @monsters = []
      @lab = Irrgarten::Labyrinth.new(@@NROWS,@@NCOLS,Irrgarten::Dice.random_pos(@@NROWS),Irrgarten::Dice.random_pos(@@NCOLS))
      i = 0
      begin
        player = Irrgarten::Player.new(i.to_s, Irrgarten::Dice.random_intelligence, Irrgarten::Dice.random_strength)
        @players.push(player)
        i += 1
      end while (i < nplayers)
      @current_player_index = Irrgarten::Dice.who_starts(i)
      @lab.spread_players(@players)
      @log = "--- Start_Game ---"
    end

    def finished
      @lab.have_a_winner?
    end

    def game_state
      game = Irrgarten::Game.new(@lab.to_s, @players.to_s, @monsters.to_s, @current_player_index, finished, @log)
      game
    end

    private def configure_labyrinth
      i = 0
      begin
        monster = Irrgarten::Monster.new("Monster# #{i}", Irrgarten::Dice.random_intelligence, Irrgarten::Dice.random_strength)
        pos = @lab.random_empty_pos

        @lab.add_monster(pos[0],pos[1],monster)

        monster.set_pos(pos[0],pos[1])
        @monsters.push(monster)
      end while i < 3

      add_block(Orientation::VERTICAL,1,3,5)
      add_block(Orientation::HORIZONTAL,5,1,4)
      @log += "Labyrinth configured: Blocks added\n"
      @log += "Labyrinth configured: #{@monsters.length}  monsters added.\n"
    end

    private def next_player
      @current_player_index = (@current_player_index + 1) % @players.length
    end

    private def actual_direction(preferred_direction)
      current_player = @players[@current_player_index]
      current_row = current_player.row
      current_col = current_player.col

      current_player.move(preferred_direction, valid_moves(current_row, current_col))
    end

    private def valid_moves(row, col)
      @lab.valid_moves(row, col)
    end

    private def combat(monster)
      current_player = @players[@current_player_index]
      rounds = 0
      winner = Irrgarten::GameCharacter::PLAYER
      player_attack = current_player.attack
      lose = monster.defend(player_attack)

      while !lose && (round < @@MAX_ROUNDS)
        winner = Irrgarten::GameCharacter::MONSTER
        rounds += 1
        monster_attack = monster.attack
        lose = current_player.defend(monster_attack)

        unless lose
          player_attack = current_player.attack
          winner = Irrgarten::GameCharacter::PLAYER
          lose = monster.defend(player_attack)
        end
      end
      log_rounds(rounds,@@MAX_ROUNDS)
      winner
    end

    private def manage_reward(winner)
      if winer == Irrgarten::GameCharacter::PLAYER
        @players[@current_player_index].receive_reward
        log_player_won
      else
        log_monster_won
      end
    end

    private def manage_resurrection
      resurrect = Irrgarten::Dice.resurrect_player

      if resurrect
        @players[@current_player_index].resurrect
        log_resurrected
      else
        log_player_skip_turn
      end
    end

    private def log_playerWon
      @log += "Player# " + @players[@current_player_index].number + "\n"
    end

    private def log_player_won
      @log += "Player# #{@players[@current_player_index].number} Won the combat!!!\n"
    end

    private def log_monster_won
      @log += "Monster Won the combat!!!\n"
    end

    private def log_resurrected
      @log += "Resurrect: Player# #{@players[@current_player_index].number}\n"
    end

    private def log_player_skip_turn
      @log += "Skip Turn: Player# #{@players[@current_player_index].number}\n"
    end

    private def log_player_no_orders
      @log += "Player# #{@players[@current_player_index].number} unexpected order\n"
    end
    private def log_no_monster
      @log += "Player# #{@players[@current_player_index].number} moves to a empty cell or can't move\n"
    end
    private def log_rounds(rounds, max)
      @log += "Done #{rounds} of #{max}\n"
    end
    def next_step(preferred_direction)
      current_player = @players[@current_player_index]
      is_dead = current_player.dead
      winner = nil

      if !is_dead
        direction = actual_direction(preferred_direction)

        if direction != preferred_direction
          log_player_no_orders
        end

        monster = @lab.put_player(direction, current_player)

        if monster.nil?
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end
      else
        manage_resurrection
      end

      end_game = finished?

      unless end_game
        next_player
      end

      end_game
    end
    private def add_block(orientation, start_row, start_col, length)
      @lab.add_block(orientation, start_row, start_col, length)
    end
    private def put_player(direction, player_ignored)
      @lab.put_player(direction, @players[@current_player_index])
    end

  end
end

