require 'set'

class Minesweeper





end


class Board
  attr_accessor :board, :mines

  def initialize
    @mines = []
    @board = Array.new(9) { Array.new(9, '?') }
    set_mines
  end

  def set_mines
    i = 0
    while i < 10
      x = rand(9)
      y = rand(9)
      if @board[x][y] == '?'
        @mines << [x, y]
        @board[x][y] = 'M'
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

  def handle_move(choice, coord)
    if choice
    end
  end

  def flag(coord)
    @board[coord[0], coord[1]] = 'F'
  end

  def reveal(coord, visited_squares = Set.new)
    num_adj_mines = adjacent_mines(coord)
    p num_adj_mines
    unless num_adj_mines == "0"
      @board[coord[0]][coord[1]] = num_adj_mines
      return
    else
      @board[coord[0]][coord[1]] = "0"

      adjacent_squares(coord).each do |sq|
        next if visited_squares.include?(sq)
        visited_squares << sq
        p sq
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

    adjacent_squares(coord).each { |pos| mines += 1 if @board[pos[0]][pos[1]] == 'M' }

    mines.to_s
  end

  def move_valid?(coord)
    coord.each do |pos|
      return false if pos < 0 || pos > 8
    end
    true
  end

end

class Player

  def get_move

    puts "Enter a x and y co-ordinate for your move: "
    x = gets.chomp
    y = gets.chomp
    [x, y]

  end

  def get_choice
    puts "Do you wish to flag a move or click? Enter 'F' to flag or 'R' to reveal"
    gets.chomp
  end
end



