require_relative 'board'
require 'byebug'

class InvalidMoveError < StandardError
end

class Piece

  attr_reader :color, :pos, :king

  def initialize(color, board, pos)
    @king = false
    @color = color
    @board = board
    @pos = pos
    board.place_piece(self, pos)
  end

  def perform_slide(target)

    x, y = @pos

    valid_slides = []

    move_diffs.each do |dx, dy|
      new_pos = [x + dx, y + dy]
      next unless @board.on_board?(new_pos)

      valid_slides << new_pos if @board[new_pos].nil?
    end

    return false unless valid_slides.include?(target)

    @board[target] = self
    @board[@pos] = nil
    @pos = target

    maybe_promote
    true

  end

  def perform_jump(target)

    opponent_color = (color == :red ? :black : :red)

    x, y = @pos
    a, b = target

    enemy_pos = [ (x+a)/2, (y+b)/2 ]

    valid_jumps = []

    move_diffs.each do |dx, dy|

      jump_over = [x + dx, y + dy]
      jump_to = [x + dx + dx, y + dy + dy]

      next unless @board.on_board?(jump_to)
      next if @board[jump_over].nil?

      if @board[jump_over].color == opponent_color && @board[jump_to].nil?
        valid_jumps << jump_to
      end

    end

    return false unless valid_jumps.include?(target)

    @board[target] = self
    @board[@pos] = nil
    @board[enemy_pos] = nil
    @pos = target

    maybe_promote
    true

  end

  def maybe_promote

    finish_line = (color == :black ? 7 : 0)
    @king = true if @pos[0] == finish_line

  end


  def move_diffs

    return [[1,1],[1,-1],[-1,1],[-1,-1]] if @king

    @color == :black ? [[1,1],[1,-1]] : [[-1,1],[-1,-1]]

  end

  def perform_moves(move_sequence)

    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
    else
      raise InvalidMoveError
    end
    nil
  end

  def perform_moves!(move_sequence)

    if move_sequence.count == 1

      if perform_slide(move_sequence.first)
      elsif perform_jump(move_sequence.first)
      else
        raise InvalidMoveError
      end

    else

      move_sequence.each do |move|
        raise InvalidMoveError unless perform_jump(move)
      end

    end
  end

  def render

    if @king
      @color == :black ? " B " : " R "
    else
      @color == :black ? " b " : " r "
    end

  end

  def valid_move_seq?(move_sequence)

    duped_board = @board.dup
    dup_piece = duped_board[@pos]

    begin
      dup_piece.perform_moves!(move_sequence)
    rescue InvalidMoveError
      false
    else
      true
    end
  end

end
