require_relative 'board'
require_relative 'piece'
require 'byebug'

class Game

  attr_reader :current, :board, :players

  def initialize
    @board = Board.new
    @players = {:black => HumanPlayer.new(:black),
                :red => HumanPlayer.new(:red)}
    @current = :red
  end

  def play
    until board.game_over?

      current = (current == :black ? :red : :black)
      board.display
      players[current].make_move(board)

    end

    puts "#{current}, you win!!"

  end

end

class HumanPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def make_move(board)

    puts "#{@color}: enter your move(s), starting with your piece, separated by commas: "
    sequence = parse(gets.chomp)

    raise "Not on the board!" unless board.on_board?(sequence[0])
    if board[sequence[0]].nil? || board[sequence[0]].color != color
      raise "Not one of your pieces!"
    end

    piece = board[sequence.shift]
    piece.perform_moves(sequence)

  rescue InvalidMoveError
    puts "Not a valid move!"
    retry
  rescue => e
    puts e
    retry

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

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
