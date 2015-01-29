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

  def display
    puts "   0  1  2  3  4  5  6  7 "
    @rows.each_with_index do |row, i|
      print "#{i} "
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


end
