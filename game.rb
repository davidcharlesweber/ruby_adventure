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

locations.each { |l| tiles[l] = rand(10) }
current_location = locations[0]
map_width = Math.sqrt(locations.count).to_i

loop do
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

  puts 'Available locations are: '
  available_locations.each do |loc|
    puts loc.to_s + ': ' + get_location(tiles, loc.split(' ').first)
  end

  input = ask 'Input coordinates: '
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
    places = %w[Canyon Valley Desert HillSide Road Forest Cemetary Mountain River Town]
    places[tiles[location]]
  end

  def lost_message(tiles, location)
    case get_location(tiles, location)
    when 'Canyon'
      'You fell on a cactus in the Canyon and died.'
    when 'Valley'
      'You were attacked by birds and died in the valley'
    when 'Desert'
      'You ran of water and died in the desert.'
    when 'HillSide'
      'The hills have eyes. You are dead.'
    when 'Road'
      'A hitchhiker caught up with you on the road. You are dead.'
    when 'Forest'
      'The wolves got your scent in the forest. You\'ve been eaten alive'
    when 'Cemetary'
      'Obviously zombies got you in the cemetary'
    when 'Mountain'
      'The cold froze you to death. You should have gotten off the mountain'
    when 'River'
      'You should have been better at swimming. You\'ve drowned'
    when 'Town'
      'I guess the towns people didn\'t like you after all'
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
}
