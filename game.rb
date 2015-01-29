require_relative 'board'
require_relative 'piece'

class Game

  def initialize
    @board = Board.new
    @players = {}
