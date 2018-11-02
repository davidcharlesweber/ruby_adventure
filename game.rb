#!/usr/bin/env ruby
require 'highline/import'

puts "Type 'exit' to quit"

difficulty = ask 'Select a difficulty (1-10): '
difficulty = difficulty.to_i

remaining_tries = 10 * (11 - difficulty)

if difficulty.class == 'String' || difficulty < 1 || difficulty > 10
  puts 'Pick a real difficulty next time...'
  exit
end

locations = %w[
  aa ab ac ad
  ba bb bc bd
  ca cb cc cd
  da db dc dd
]

tiles = {}

load_anscii

locations.each { |l| tiles[l] = rand(10) }
current_location = locations[0]
map_width = Math.sqrt(locations.count).to_i

loop do
  clear_screen
  puts "\033[1mCurrently playing difficulty level:\033[0m #{difficulty}"
  puts "\033[1mRemaing Moves:\033[0m #{remaining_tries}";puts
  puts instance_variable_get("@#{get_location(tiles, current_location).downcase}")
  puts
  draw_map(locations, tiles, map_width, current_location)
  puts
  if current_location.to_s == locations[-1]
    puts "\e[36mCongrats you won!\e[0m"
    break
  elsif remaining_tries == 0
    puts "\e[31m#{lost_message(tiles, current_location)}\e[0m\n"
    break
  end

  puts "Current location is: #{get_location(tiles, current_location)}\n"

  available_locations = []
  positions = current_location.split('')
  west = "#{positions[0]}#{(positions[1].to_s.ord - 1).chr}"
  east = "#{positions[0]}#{(positions[1].to_s.ord + 1).chr}"
  south = "#{(positions[0].to_s.ord + 1).chr}#{positions[1]}"
  north = "#{(positions[0].to_s.ord - 1).chr}#{positions[1]}"

  available_locations.push(north + ' north') if locations.include? north
  available_locations.push(south + ' south') if locations.include? south
  available_locations.push(east + ' east') if locations.include? east
  available_locations.push(west + ' west') if locations.include? west

  puts 'Adjacent locations are: '
  available_locations.each do |loc|
    puts loc.split(' ')[1].to_s + ': ' + get_location(tiles, loc.split(' ').first)
  end
  puts

  input = ask 'Try which direction?: '
  input = convert_input(input)

  remaining_tries -= 1

  break if input == 'exit'

  if available_locations.index { |s| s.include?(input) }
    coordinate = available_locations.select { |s| s.include?(input) }
    coordinate = coordinate.first.split(' ').first

    if tiles[coordinate] < (tiles[current_location] + (10 - difficulty)) && tiles[coordinate] > (tiles[current_location] - (10 - difficulty))
      current_location = coordinate
    else
      puts "\e[31mYou couldn\'t make the trip there\e[0m\n"
    end
  else
    puts 'Bad selection.'
  end
end

BEGIN {
  def get_location(tiles, location)
    places = %w[Bridge Sofa Town Barn Chapel Castle Beach Mountain Windmill Village]
    places[tiles[location]]
  end

  def lost_message(tiles, location)
    case get_location(tiles, location)
    when 'Bridge'
      'A strong cross wind blew you off the bridge.'
    when 'Sofa'
      'You should have played the game instead of sat on the sofa.'
    when 'Town'
      'The police arrested you for loitering.'
    when 'Barn'
      'You let yourself be accidentally trampled by a cow.'
    when 'Chapel'
      'Some terrible thing happened. Not sure what because it\'s a chapel. But you are dead now.'
    when 'Castle'
      'A mystious knight found and beheaded you.'
    when 'Beach'
      'A shark ate you while you went out for a swim.'
    when 'Mountain'
      'The cold froze you to death. You should have gotten off the mountain'
    when 'Windmill'
      'A blade of the windmill fell off and crushed you. You shouldn\'t have been standing there.'
    when 'Village'
      'The village people wouldn\'t let you leave. Like in that one movie'
    else
      'You died from something else'
    end
  end

  def print_name(tiles, location, current_location)
    if location == current_location
      print "\e[31m#{get_location(tiles, location).center(20)}\e[0m"
    else
      print get_location(tiles, location).center(20)
    end
  end

  def draw_map(locations, tiles, map_width, current_location)
    locations.each_slice(map_width) do |group|
      group.each do |l|
        print_name(tiles, l, current_location)
      end
      puts
    end
  end

  def clear_screen
    if RUBY_PLATFORM =~ /win32|win64|\.NET|windows|cygwin|mingw32/i
       system('cls')
     else
       system('clear')
    end
 end

  def load_anscii
    fh = open './1bridge.txt';@bridge = fh.read;fh.close
    fh = open './2sofa.txt';@sofa = fh.read;fh.close
    fh = open './3town.txt';@town = fh.read;fh.close
    fh = open './4barn.txt';@barn = fh.read;fh.close
    fh = open './5chapel.txt';@chapel = fh.read;fh.close
    fh = open './6castle.txt';@castle = fh.read;fh.close
    fh = open './7beach.txt';@beach = fh.read;fh.close
    fh = open './8mountain.txt';@mountain = fh.read;fh.close
    fh = open './9windmill.txt';@windmill = fh.read;fh.close
    fh = open './10village.txt';@village = fh.read;fh.close
  end

  def convert_input(input)
    if input.downcase == 'up' || input.downcase == 'u' || input.downcase == 'north' || input.downcase == 'n'
      'north'
    elsif input.downcase == 'down' || input.downcase == 'd' || input.downcase == 'south' || input.downcase == 's'
      'south'
    elsif input.downcase == 'left' || input.downcase == 'l' || input.downcase == 'west' || input.downcase == 'w'
      'west'
    elsif input.downcase == 'right' || input.downcase == 'r' || input.downcase == 'east' || input.downcase == 'e'
      'east'
    else
      input
    end
  end
}
