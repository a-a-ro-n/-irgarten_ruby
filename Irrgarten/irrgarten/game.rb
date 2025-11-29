# frozen_string_literal: true

module Irrgarten
  class Game
    @@MAX_ROUNDS = 10
    @@NROWS = 10
    @@NCOLS = 10

    def initialize(nplayers)
      @players = []
      @monsters = []
      @lab = Labyrinth.new(@@NROWS,@@NCOLS,Dice.random_pos(@@NROWS),Dice.random_pos(@@NCOLS))
      @log = "--- Start_Game ---\n"
      i = 0
      begin
        player = Player.new(i.to_s, Dice.random_intelligence, Dice.random_strength, 10)
        @players.push(player)
        i += 1
      end while (i < nplayers)
      configure_labyrinth
      @current_player_index = Dice.who_starts(nplayers)
      @lab.spread_players(@players)
    end

    def finished
      @lab.have_a_winner?
    end

    def game_state
      GameState.new(@lab.to_s, @players, @monsters, @current_player_index, finished, @log)
    end

    private def configure_labyrinth
      i = 0
      begin
        monster = :Monster.new("Monster# #{i}", Dice.random_intelligence, Dice.random_strength)
        pos = @lab.random_empty_pos

        @lab.add_monster(pos[0],pos[1],monster)

        monster.set_pos(pos[0],pos[1])
        @monsters.push(monster)

        i += 1
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
      winner = GameCharacter::PLAYER
      player_attack = current_player.attack
      lose = monster.defend(player_attack)

      while !lose && (rounds < @@MAX_ROUNDS)
        winner = GameCharacter::MONSTER
        rounds += 1
        monster_attack = monster.attack
        lose = current_player.defend(monster_attack)

        unless lose
          player_attack = current_player.attack
          winner = GameCharacter::PLAYER
          lose = monster.defend(player_attack)
        end
      end
      log_rounds(rounds,@@MAX_ROUNDS)
      winner
    end

    private def manage_reward(winner)
      if winner == GameCharacter::PLAYER
        @players[@current_player_index].receive_reward
        log_player_won
      else
        log_monster_won
      end
    end

    private def manage_resurrection
      resurrect = Dice.resurrect_player
      if resurrect
        @players[@current_player_index].resurrect
        log_resurrected
      else
        log_player_skip_turn
      end
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
      @log += "Player# #{@players[@current_player_index].number} move\n"
    end
    private def log_rounds(rounds, max)
      @log += "Done #{rounds} of #{max}\n"
    end
    def next_step(preferred_direction)
      current_player = @players[@current_player_index]
      is_dead = current_player.dead

      if !is_dead
        direction = actual_direction(preferred_direction)

        if direction != preferred_direction
          log_player_no_orders
        end

        monster = put_player(direction, current_player)

        if monster.nil?
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end
      else
        manage_resurrection
      end

      end_game = finished

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

