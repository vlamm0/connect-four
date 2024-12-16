# requirements
require_relative './player'

# Connect Four
class Game
  attr_accessor :data, :players, :turn

  def initialize
    @data = Array.new(6) { Array.new(7, '__') }
    @players = [Player.new('1', "\u26AA"), Player.new('2', "\u26AB")]
    @turn = 0
  end

  def display_board
    data.each { |row| puts "|#{row.join('|')}|" }
    7.times { |i| print " #{i + 1} " }
    puts
  end

  def update_data(row, col, sym)
    pos = [5 - row, col]
    data[pos[0]][pos[1]] = sym
    pos
  end

  # select a col and place piece all the way down
  def place_piece(col, sym)
    data.reverse.each_with_index do |row, i|
      next unless row[col] == '__'

      # returns the updated data's position
      return update_data(i, col, sym)
    end
    puts 'UNAVAILABLE'
    go
  end

  def go(start = nil)
    display_board if start == true
    input = curr_player.prompt
    pos = place_piece(input - 1, curr_player.icon)
    connect?(pos)
  end

  def curr_player
    turn.even? ? players[0] : players[1]
  end

  def valid_pos?(pos)
    pos[0].between?(0, 5) && pos[1].between?(0, 6)
  end

  def crawl(pos, sum = 0)
    while valid_pos?(pos) && data[pos[0]][pos[1]] == curr_player.icon
      sum += 1
      pos = yield(pos)
    end
    sum
  end

  def vert(pos)
    up = crawl(pos) { |new_pos| [new_pos[0] + 1, new_pos[1]] }
    crawl([pos[0] - 1, pos[1]], up) { |new_pos| [new_pos[0] - 1, new_pos[1]] }
  end

  def hor(pos)
    left = crawl(pos) { |new_pos| [new_pos[0], new_pos[1] - 1] }
    crawl([pos[0], pos[1] + 1], left) { |new_pos| [new_pos[0], new_pos[1] + 1] }
  end

  def crawl_diag(pos, direction)
    crawl(pos) { |new_pos| [new_pos[0] + direction[0], new_pos[1] + direction[1]] }
  end

  def diag(pos)
    # Check the first diagonal (top-left to bottom-right)
    cross1 = crawl_diag(pos, [1, 1]) + crawl_diag([pos[0] - 1, pos[1] - 1], [-1, -1])
    # Check the second diagonal (top-right to bottom-left)
    cross2 = crawl_diag(pos, [1, -1]) + crawl_diag([pos[0] - 1, pos[1] + 1], [-1, 1])
    cross1 > cross2 ? cross1 : cross2
  end

  def dfs(pos)
    arr = [vert(pos), hor(pos), diag(pos)]
    arr.max >= 4
  end

  def connect?(pos)
    display_board
    dfs(pos) ? curr_player.wins : continue_game
  end

  def continue_game
    @turn += 1
    go
  end
end

new_game = Game.new
# white_piece = new_game.players[0].icon
# black_piece = new_game.players[1].icon
new_game.go(true)

# connect? missing arg
