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

  private
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


class ComputerPlayer

  attr_reader :color

  def initialize(color)
    @color = color
  end

  def make_move(board)

    my_pieces =board.pieces.select {|piece| piece.color == color}

    all_jump_moves = []
    my_pieces.each do |piece|
      piece.valid_jumps.each do |jump|
        all_jump_moves << [piece.pos, jump]
      end
    end

    all_slide_moves = []
    my_pieces.each do |piece|
      piece.valid_slides.each do |slide|
        all_slide_moves << [piece.pos, slide]
      end
    end

    if all_jump_moves.any?
      move = all_jump_moves.sample
    else
      move = all_slide_moves.sample
    end

    piece = board[move.shift]
    piece.perform_moves(move)

  end

end
