# 2 players for conn 4
class Player
  attr_accessor :icon, :player

  def initialize(player, sym)
    @player = player
    @icon = sym
  end

  def prompt(welcome = "\n\nIt is PLAYER_#{player}'s turn")
    puts welcome
    puts 'Choose a slot 1-7'
    input = gets.chomp.to_i
    input.between?(1, 7) ? input : prompt("UNAVAILABLE\n\nIt is STILL PLAYER_#{player}'s turn")
  end

  def wins
    puts "\n\n\n\nPLAYER #{player} WINS!!!\n\n\n\n"
  end
end
