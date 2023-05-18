#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'tatum'
TTM.io = STDOUT

# output stuff
TTM.indent('whatever') do
	TTM.puts 'dude'
end

# done
puts '[done]'
