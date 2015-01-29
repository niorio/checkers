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


  def get_player(color)
    puts "#{color}: Human(H) or Computer(C)?"
    case gets.chomp.upcase
    when "H"
      return HumanPlayer.new(color)
    when "C"
      return ComputerPlayer.new(color)
    else
      get_player(color)
    end
  end

  players = Hash.new

  players[:black] = get_player(:black)
  players[:red] = get_player(:red)

  game = Game.new(players)
  game.play

end
