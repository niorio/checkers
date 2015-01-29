require_relative 'board'
require_relative 'piece'

class Game

  attr_reader :current, :board, :players

  def initialize
    @board = Board.new
    @players = {:black => HumanPlayer.new(:b),
                :red => HumanPlayer.new(:r)}
    @current = :red
  end

  def play
    until board.game_over?
      current = (current == :black ? :red : :black)

      board.display
      sequence = players[current].get_move

      piece = board[sequence.shift]
      piece.perform_moves[sequence]
    end
  end

end

class HumanPlayer

  def initialize(color)
    @color = color
  end

  def get_move
    puts "Enter you move, starting with your piece, separated by commas: "
    parse(gets.chomp)
  end

  def parse(input)
    sequence = input.split(",")

    sequence.map do |coord|
      coord = coord.split("")
      coord[0] = coord[0].downcase.ord - 97
      coord[1] = coord[1].to_i
      coord[1] -= 1
      coord.reverse
    end

  end


end
