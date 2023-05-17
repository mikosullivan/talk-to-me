#!/usr/bin/ruby -w
require_relative './dir.rb'

# config
path = './debug.txt'

# output to file
TTM.io = path
TTM.clear

TTM.indent('whatever') do
	TTM.puts 'dude'
end

puts File.read(path)


# done
puts '[done]'