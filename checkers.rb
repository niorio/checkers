require 'byebug'

class Board

  def initialize
    @rows = Array.new(8) { Array.new(8) }
  end

  def [](pos)
    raise "not on board" unless on_board?(pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, value)
    raise "not on board" unless on_board?(pos)
    row, col = pos
    @rows[row][col] = value
  end

  def place_piece(piece, pos)
    self[pos] = piece
  end

  def on_board?(pos)
    pos.all? { |coord| coord.between?(0,7) }
  end


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
      valid_slides << new_pos if @board[new_pos].nil?
    end

    raise "not a valid move" unless valid_slides.include?(target)

    @board[target] = self
    @board[@pos] = nil
    @pos = target

    maybe_promote

  end

  def perform_jump(target)

    opponent_color = (color == :r ? :b : :r)

    x, y = @pos
    a, b = target

    enemy_pos = [ (x+a)/2, (y+b)/2 ]

    valid_jumps = []

    move_diffs.each do |dx, dy|
      jump_over = [x + dx, y + dy]
      jump_to = [x + dx + dx, y + dy + dy]

      next if @board[jump_over].nil?

      if @board[jump_over].color == opponent_color && @board[jump_to].nil?
        valid_jumps << jump_to
      end
    end

    raise "not a valid move" unless valid_jumps.include?(target)

    @board[target] = self
    @board[@pos] = nil
    @board[enemy_pos] = nil
    @pos = target

    maybe_promote

  end

  def maybe_promote

    finish_line = (color == :b ? 7 : 0)
    @king = true if @pos[0] == finish_line

  end


  def move_diffs

    return [[1,1],[1,-1],[-1,1],[-1,-1]] if @king

    @color == :b ? [[1,1],[1,-1]] : [[-1,1],[-1,-1]]

  end

end
