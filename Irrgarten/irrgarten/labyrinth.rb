# frozen_string_literal: true
require_relative 'labyrinth_character'
module Irrgarten
  class Labyrinth
    @@BLOCK_CHAR = 'X'
    @@EMPTY_CHAR = '-'
    @@MONSTER_CHAR = 'M'
    @@COMBAT_CHAR = 'C'
    @@EXIT_CHAR = 'E'

    @@ROW = 0
    @@COL = 1

    def initialize(n_rows, n_cols, exit_row, exit_col)
      @n_rows = n_rows
      @n_cols = n_cols
      @exit_row = exit_row
      @exit_col = exit_col

      @grid = Array.new(@n_rows){Array.new(@n_cols)}
      @monster_pos = Array.new(@n_rows){Array.new(@n_cols)}
      @player_pos = Array.new(@n_rows){Array.new(@n_cols)}

      for i in 0..@n_rows-1 do
        for j in 0..@n_cols-1 do
          @monster_pos[i][j] = nil
          @player_pos[i][j] = nil
          @grid[i][j] = @@EMPTY_CHAR
        end
      end

      @grid[@exit_row][@exit_col] = @@EXIT_CHAR
    end

    def spread_players(players)
      for player in players
        pos = random_empty_pos
        put_player_2d(-1,-1,pos[@@ROW],pos[@@COL],player)
      end
    end

    def have_a_winner?
      winner = false

      for i in 0...@n_rows do
        for j in 0...@n_cols do
          player = @player_pos[i][j]
          if player != nil && i == @exit_row && j == @exit_col
            winner = true
          end
        end
      end

      winner
    end

    def to_s
      result = ""
      for i in 0..@n_rows-1 do
        row_string = ""
        for j in 0..@n_cols-1 do
          if @player_pos[i][j] != nil
            if combat_pos(i,j)
              row_string += " #{@@COMBAT_CHAR}"
            else
              row_string += " #{@player_pos[i][j].number}"
            end
          else
            row_string += " #{@grid[i][j]}"
          end
        end
        result += row_string + "\n"
      end

      return result
    end

    def add_monster(row, col, monster)
      if empty_pos(row, col)
        @grid[row][col] = @@MONSTER_CHAR
        monster.set_pos(row, col)
        @monster_pos[row][col] = monster
      end
    end

    def put_player(direction, player)
      old_row = player.row
      old_col = player.col
      new_pow = dir_2_pos(old_row, old_col, direction)
      put_player_2d(old_row, old_col, new_pow[@@ROW], new_pow[@@COL], player)
    end

    def add_block(orientation, start_row, start_col, length)
      if orientation == Orientation::VERTICAL
        inc_row = 1
        inc_col = 0
      else
        inc_row = 0
        inc_col = 1
      end

      row = start_row
      col = start_col

      while pos_ok(row, col) && empty_pos(row, col) && (length > 0)
        @grid[row][col] = @@BLOCK_CHAR
        length -= 1
        row += inc_row
        col += inc_col
      end
    end

    def valid_moves(row, col)
      valid = []

      if can_step_on(row + 1, col)
        valid.push(Directions::DOWN)
      end
      if can_step_on(row - 1, col)
        valid.push(Directions::UP)
      end
      if can_step_on(row, col + 1)
        valid.push(Directions::RIGHT)
      end
      if can_step_on(row, col - 1)
        valid.push(Directions::LEFT)
      end

      valid
    end

    private def pos_ok(row, col)
      row >= 0 && row < @n_rows && col >= 0 && col < @n_cols
    end

    private def empty_pos(row, col)
      @grid[row][col] == @@EMPTY_CHAR
    end

    private def monster_pos(row, col)
      @grid[row][col] == @@MONSTER_CHAR
    end

    private def combat_pos(row, col)
      @grid[row][col] == @@COMBAT_CHAR
    end

    private def exit_pos(row, col)
      @grid[row][col] == @@EXIT_CHAR
    end

    private def can_step_on(row, col)
      if pos_ok(row, col)
        empty_pos(row, col) || monster_pos(row, col) || exit_pos(row, col)
      end
    end

    private def update_old_pos(row, col)
      if pos_ok(row, col)
        if combat_pos(row, col)
          @grid[row][col] = @@MONSTER_CHAR
        else
          @grid[row][col] = @@EMPTY_CHAR
        end

        @player_pos[row][col] = nil
      end
    end

    private def dir_2_pos(row, col, direction)
      next_pos = [row, col]
      case direction
        when Directions::UP
          next_pos[@@ROW] -= 1
        when Directions::DOWN
          next_pos[@@ROW] += 1
        when Directions::LEFT
          next_pos[@@COL] -= 1
        when Directions::RIGHT
          next_pos[@@COL] += 1
      end
      next_pos
    end

    public def random_empty_pos # tendria que ser en privado pero no se como puedo añadir mosntruos
      pos = []
      begin

        pos[@@ROW] = Dice.random_pos(@n_rows)
        pos[@@COL] = Dice.random_pos(@n_cols)

      end until empty_pos(pos[@@ROW], pos[@@COL])

      pos
    end

    # Dentro de la clase Labyrinth en Ruby

    private def put_player_2d(old_row, old_col, row, col, player)
      monster = nil
      if can_step_on(row, col)
        if pos_ok(old_row, old_col)
          update_old_pos(old_row, old_col)
        end

        is_monster_pos = monster_pos(row, col)

        if is_monster_pos
          set_c(row, col, @@COMBAT_CHAR)
          monster = @monster_pos[row][col]
          set_p(row, col, player)
        else
          player_character = player.number
          set_c(row, col, player_character)
          set_p(row, col, player)
        end

        player.set_pos(row, col)

      end
      monster
    end

    private def set_p(row, col, player)
      if pos_ok(row, col)
        @player_pos[row][col] = player
      end
    end

    private def set_c(row, col, char)
      if pos_ok(row, col)
        @grid[row][col] = char
      end
    end

  end
end

