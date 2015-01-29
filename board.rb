require_relative 'piece'

class Board

  def initialize(fill = true)
    @rows = Array.new(8) { Array.new(8) }

    populate if fill
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

  def pieces
    @rows.flatten.compact
  end

  def dup
    duped_board = Board.new(false)
    pieces.each do |piece|
      Piece.new(piece.color, duped_board, piece.pos)
    end
    duped_board
  end


  def display
    puts "   a  b  c  d  e  f  g  h "
    @rows.each_with_index do |row, i|
      print "#{i+1} "
      row.each do |space|
        if space.nil?
          print " _ "
        else
          print space.render
        end
      end
      puts
    end
    nil
  end

  def populate

    #black
    div = 0
    3.times do |r|
      div = (div == 1) ? 0 : 1
      8.times do |c|
        Piece.new(:b, self, [r,c]) if c % 2 == div
      end
    end

    #red
    div = 1
    7.downto(5) do |r|
      div = (div == 1) ? 0 : 1
      8.times do |c|
        Piece.new(:r, self, [r,c]) if c % 2 == div
      end
    end

  end

  def game_over?
    pieces.none? {|piece| piece.color == :b} ||
    pieces.none? {|piece| piece.color == :r}
  end

end
