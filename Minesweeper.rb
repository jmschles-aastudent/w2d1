require 'set'

class Minesweeper

  def initialize
    @board = Board.new(get_game_size)
    @player = Player.new
  end

  def get_game_size
    puts "Choose a game size: small (s) or large (l): "
    size = gets.chomp
    until size == "l" || size == "s"
      puts "Invalid choice, please enter s or l."
      size = gets.chomp
    end
    if size == 's'
      return [9, 10]
    else
      return [16, 40]
    end
  end

  def play
    won = false
    while true
      @board.print_board

      if @board.all_mines_flagged?
        won = true
        break
      end

      break unless @board.handle_move(@player.get_move)
    end

    if won
      puts "Yay! You win!"
    else
      puts "You suck at minesweeper."
    end
  end
end


class Board
  attr_accessor :board, :mines

  def initialize(size)
    @size = size
    @mines = []
    @board = Array.new(@size[0]) { Array.new(@size[0], '?') }
    set_mines
  end

  def set_mines
    i = 0
    while i < @size[1]
      x = rand(@size[0])
      y = rand(@size[0])
      unless @mines.include? [x, y]
        @mines << [x, y]
        i += 1
      end
    end
  end

  def print_board
    @board.each do |row|
      row.each do |pos|
        print "#{pos} "
      end

      puts
    end

    nil
  end

  def handle_move(move)
    case move[0]
    when 'F'
      @board[move[1]][move[2]] = 'F'
    when 'R'
      return false if @mines.include?([move[1], move[2]])
      reveal([move[1], move[2]])
    end

    true
  end

  def flag(coord)
    @board[coord[0], coord[1]] = 'F'
  end

  def reveal(coord, visited_squares = Set.new)
    num_adj_mines = adjacent_mines(coord)
    unless num_adj_mines == "_"
      @board[coord[0]][coord[1]] = num_adj_mines
      return
    else
      @board[coord[0]][coord[1]] = "_"

      adjacent_squares(coord).each do |sq|
        next if visited_squares.include?(sq)
        visited_squares << sq
        reveal(sq, visited_squares)
      end
    end
  end

  def adjacent_squares(coord)
    adj_squares = []
    [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]].each do |delta|
      x = coord[0] + delta[0]
      y = coord[1] + delta[1]
      adj_squares << [x, y] if move_valid?([x, y])
    end

    adj_squares
  end

  def adjacent_mines(coord)
    mines = 0
    x, y = coord

    adjacent_squares(coord).each { |pos| mines += 1 if @mines.include?(pos) }

    return '_' if mines == 0
    mines.to_s
  end

  def move_valid?(coord)
    coord.each do |pos|
      return false if pos < 0 || pos > @size[0] - 1
    end
    true
  end

  def all_mines_flagged?
    @mines.each do |pos|
      return false unless @board[pos[0]][pos[1]] == 'F'
    end

    true
  end

end

class Player

  def get_move
    type = get_choice
    x, y = get_position

    [type, x, y]
  end

  def get_position
    puts "Enter a x co-ordinate for your move: "
    x = gets.chomp.to_i
    puts "Enter a y co-ordinate for your move: "
    y = gets.chomp.to_i
    [x, y]
  end

  def get_choice
    puts "Do you wish to flag a move or click? Enter 'F' to flag or 'R' to reveal"
    input = gets.chomp
    until input == 'F' || input == 'R'
      puts "Invalid input. Please enter F or R"
      gets.chomp
    end
    input
  end
end


