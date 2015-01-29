require_relative 'board'
require_relative 'piece'
require_relative 'player.rb'
require 'byebug'

class Game

  attr_reader :current, :board, :players

  def initialize
    @board = Board.new
    @players = {:black => HumanPlayer.new(:black),
                :red => ComputerPlayer.new(:red)}
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
  game = Game.new
  game.play
end
