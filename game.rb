#!/usr/bin/env ruby
require 'highline/import'

puts "Type 'exit' to quit"

difficulty = ask 'Select a difficulty (1-10): '

locations = [
  'aa', 'ab', 'ac', 'ad',
  'ba', 'bb', 'bc', 'bd',
  'ca', 'cb', 'cc', 'cd',
  'da', 'db', 'dc', 'dd'
]

tiles = {}

locations.each { |l| tiles[l] = rand(10) }

current_location = locations[0]
loop do
  if current_location.to_s == locations[-1]
    print 'Congrats you won!'
    break
  end

  puts "Current tile is: #{
    if tiles[current_location] > 0 && tiles[current_location] < 3
      'Valley'
    elsif tiles[current_location] > 3 && tiles[current_location] < 7
      'Hill side'
    else
      'Mountain Top'
    end
  }\n"

  available_locations = []
  positions = current_location.split('')
  available_locations.push("#{positions[0]}#{(positions[1].to_s.ord + 1).chr}") if locations.include? "#{positions[0]}#{(positions[1].to_s.ord + 1).chr}"
  available_locations.push("#{positions[0]}#{(positions[1].to_s.ord - 1).chr}") if locations.include? "#{positions[0]}#{(positions[1].to_s.ord - 1).chr}"
  available_locations.push("#{(positions[0].to_s.ord + 1).chr}#{positions[1]}") if locations.include? "#{(positions[0].to_s.ord + 1).chr}#{positions[1]}"
  available_locations.push("#{(positions[0].to_s.ord - 1).chr}#{positions[1]}") if locations.include? "#{(positions[0].to_s.ord - 1).chr}#{positions[1]}"

  puts "Available locations are: "
  available_locations.each do |loc|
    puts loc.to_s + ": " + if tiles[loc] > 0 && tiles[loc] < 3
                              'Valley'
                            elsif tiles[loc] > 3 && tiles[loc] < 7
                              'Hill side'
                            else
                              'Mountain Top'
                            end
  end

  input = ask 'Input text: '
  break if input == 'exit'

  if available_locations.include? input
    if tiles[input] < (tiles[current_location] + 5) && tiles[input] > (tiles[current_location] - 5)
      current_location = input
    else
      puts "\e[31mYou couldn\'t make the climb there\e[0m\n"
    end
  else
    puts 'Bad selection.'
  end
end
