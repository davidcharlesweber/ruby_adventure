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
loop do
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
  available_locations.push("#{positions[0]}#{(positions[1].to_s.ord + 1).chr}") if locations.include? "#{positions[0]}#{(positions[1].to_s.ord + 1).chr}"
  available_locations.push("#{positions[0]}#{(positions[1].to_s.ord - 1).chr}") if locations.include? "#{positions[0]}#{(positions[1].to_s.ord - 1).chr}"
  available_locations.push("#{(positions[0].to_s.ord + 1).chr}#{positions[1]}") if locations.include? "#{(positions[0].to_s.ord + 1).chr}#{positions[1]}"
  available_locations.push("#{(positions[0].to_s.ord - 1).chr}#{positions[1]}") if locations.include? "#{(positions[0].to_s.ord - 1).chr}#{positions[1]}"

  puts 'Available locations are: '
  available_locations.each do |loc|
    puts loc.to_s + ': ' + get_location(tiles, loc)
  end

  input = ask 'Input coordinates: '
  remaining_tries -= 1

  break if input == 'exit'

  if available_locations.include? input
    if tiles[input] < (tiles[current_location] + (10 - difficulty)) && tiles[input] > (tiles[current_location] - (10 - difficulty))
      current_location = input
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
    location = get_location(tiles, location)
    case location
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
      'Obvisouly zombies got you in the cemetary'
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
}
