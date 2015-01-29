require 'byebug'

class Board

  def initialize
    @rows = Array.new(8) { Array.new(8) }
  end

  def [](pos)
    row, col = pos
    @rows[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @rows[row][col] = value
  end

  def place_piece(piece, pos)
    self[pos] = piece
  end

end

class Piece

  attr_reader :color, :pos

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

  end

  def move_diffs

    @color == :b ? [[1,1],[1,-1]] : [[-1,1],[-1,-1]]

  end

end
