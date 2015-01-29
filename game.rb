require_relative 'board'
require_relative 'piece'
require_relative 'player.rb'
require 'byebug'

class Game

  attr_reader :current, :board, :players

  def initialize(players)
    @board = Board.new
    @players = players
    @current = :red
  end

  def play
    until board.game_over?

      current = (current == :black ? :red : :black)
      board.display
      players[current].make_move(board)

    end

    board.display
    puts "#{current}, you win!!"

  end

end

if __FILE__ == $PROGRAM_NAME

  players = Hash.new

  puts "Black: Human (H) or Computer(C)?"
  if gets.chomp.upcase == "H"
    players[:black] = HumanPlayer.new(:black)
  else
    players[:black] = ComputerPlayer.new(:black)
  end

  puts "Red: Human (H) or Computer(C)?"
  if gets.chomp.upcase == "H"
    players[:red] = HumanPlayer.new(:red)
  else
    players[:red] = ComputerPlayer.new(:red)
  end

  game = Game.new(players)
  game.play
end
