class Minesweeper





end


class Board
  attr_accessor :board, :mines

  def initialize
    @board = Array.new(9) { Array.new(9, '?') }
    set_mines
  end

  def set_mines
    i = 0
    while i < 10
      x = rand(9)
      y = rand(9)
      if @board[x][y] == '?'
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

  def reveal

  end

  def adjacent_mines(coord)
    mines = 0
    x, y = coord

    deltas = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    deltas.each { |i, j| mines += 1 if move_valid?([x+i, y+j]) && @board[x+i][y+j] == 'M' }

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
