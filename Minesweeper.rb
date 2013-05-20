class Minesweeper





end


class Board
  attr_accessor :board, :mines

  def initialize
    @board = Array.new(9) { Array.new(9, nil) }
    set_mines
  end

  def set_mines
    i = 0
    while i < 10
      x = rand(9)
      y = rand(9)
      if @board[x][y].nil?
        @board[x][y] = true
        i += 1
      end
    end

    p i
  end

  def print_board
    @board.each do |row|
      row.each do |pos|
        print "#{pos} "
      end

      puts
    end
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

