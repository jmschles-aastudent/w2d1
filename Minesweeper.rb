require 'set'
require 'yaml'

class Minesweeper

  def initialize
    case new_or_load
    when 'L'
      load_game
    when 'N'
      create_new_game
    end
    @player = Player.new
    # play
  end

  def self.get_high_scores
    all_scores = File.readlines("highscores.txt")
    highscores = all_scores.map {|score| score.chomp.to_f}
    highscores.sort!
    highscores = highscores[0..9]

    highscores.each { |score| puts "#{score} seconds" }

    true
  end

  def play
    @board.start_time = Time.now
    state = nil
    while true
      @board.print_board

      if @board.all_mines_flagged?
        state = :win
        break
      end

      state = @board.handle_move(@player.get_move)
      break if state == :lose || state == :save
    end

    end_game(state)

  end

  private

  def end_game(state)

    total_time = Time.now - @board.start_time + @board.time_so_far

    if state == :win
      puts "Yay! You won in #{total_time.ceil} seconds."
      File.open("highscores.txt", "a") { |f| f.puts total_time }

    elsif state == :lose
      @board.reveal_mines
      @board.print_board
      puts "BOOM!"
      5.times do
        puts "You suck at minesweeper."
        sleep(1)
      end

    else
      puts "See you later!"
    end

    nil
  end

  def load_game
    puts "Input filename: "
    filename = gets.chomp
    yaml_board = File.read(filename)
    @board = YAML::load(yaml_board)
  end

  def create_new_game
    @board = Board.new(get_game_size)
  end

  def get_game_size
    puts "Choose a game size: small (s) or large (l): "
    size = gets.chomp.downcase
    until size == "l" || size == "s"
      puts "Invalid choice, please enter s or l."
      size = gets.chomp.downcase
    end
    if size == 's'
      return [9, 10]
    else
      return [16, 40]
    end
  end

  def new_or_load
    puts "Start new game (N) or load (L)?"
    choice = gets.chomp.upcase
    until choice == 'N' || choice == 'L'
      choice = new_or_load
    end
    choice
  end
end


class Board
  attr_accessor :board, :mines, :start_time
  attr_reader :time_so_far

  def initialize(size)
    @time_so_far = 0
    @start_time = nil
    @size = size
    @mines = []
    @board = Array.new(@size[0]) { Array.new(@size[0], '?') }
    set_mines
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
    case move.shift
    when 'F'
      flag(move)
    when 'U'
      unflag(move)
    when 'R'
      return :lose if @mines.include?([move[0], move[1]])
      reveal([move[0], move[1]])
    when 'S'
      return save_game

    end

    return true
  end

  def all_mines_flagged?
    @mines.each do |pos|
      return false unless @board[pos[0]][pos[1]] == 'F'
    end

    true
  end

  def reveal_mines
    @mines.each do |mine|
      @board[mine[0]][mine[1]] = '*'
    end
  end

  private

  def save_game
    puts "Enter a filename: "
    filename = gets.chomp

    @time_so_far += Time.now - @start_time

    File.open(filename || "savegame.txt", "w") do |f|
      f.puts self.to_yaml
    end

    :save
  end

  def flag(coord)
    @board[coord[0]][coord[1]] = 'F'
  end

  def unflag(coord)
    @board[coord[0]][coord[1]] = '?'
  end

  def reveal(coord, visited_squares = Set.new)
    num_adj_mines = adjacent_mines(coord)
    unless num_adj_mines == "_"
      @board[coord[0]][coord[1]] = num_adj_mines unless @board[coord[0]][coord[1]] == 'F'
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

end

class Player
  CHOICES = ['F', 'R', 'U', 'S'].to_set

  def get_move
    type = get_choice
    return ['S'] if type == 'S'
    x, y = get_position

    [type, x, y]
  end

  private

  def get_position
    puts "Enter a x co-ordinate for your move: "
    x = gets.chomp.to_i
    puts "Enter a y co-ordinate for your move: "
    y = gets.chomp.to_i
    until [x, y].all? { |n| n.is_a?(Fixnum) && n >= 0 }
      puts "Invalid coordinates, try again."
      x, y = get_position
    end

    [x, y]
  end

  def get_choice
    puts "Enter 'F' to flag, 'R' to reveal, 'U' to unflag,"
    puts "or 'S' to save your game and quit."
    input = gets.chomp.upcase
    until CHOICES.include?(input)
      puts "Invalid input. Please enter F, R, U, or S"
      input = gets.chomp.upcase
    end
    input
  end
end


