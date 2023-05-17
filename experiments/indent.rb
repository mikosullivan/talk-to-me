#!/usr/bin/ruby -w
require_relative './dir.rb'

# output stuff
TTM.indent('whatever') do
	TTM.hr do
		TTM.puts 'dude'
	end
end

# done
puts '[done]'