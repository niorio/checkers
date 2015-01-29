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

  def initialize(color, board, pos)
    @king = false
    @color = color
    @board = board
    @pos = pos
    board.place_piece(self, pos)
  end

  def perform_slide(target)

    x, y = @pos

    valid_slides =[]

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
    # x , y = @pos
    #
    # valid_jumps = []
    #
    # jump_diffs.each do |dx, dy|
    #   new_pos = [x + dx, y + dy]
    #
    #
    #
  end
  #
  # def jump_diffs
  #
  #   @color == :r ? [[2,2],[2,-2]] : [[-2,2],[-2,-2]]
  #
  # end
  #

  def move_diffs

    @color == :b ? [[1,1],[1,-1]] : [[-1,1],[-1,-1]]

  end

end
