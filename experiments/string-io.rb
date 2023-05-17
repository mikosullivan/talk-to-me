#!/usr/bin/ruby -w
require_relative './dir.rb'

# set as cache
TTM.io = TTM::Cache.new()

# output stuff
TTM.indent('whatever') do
	TTM.hr do
		TTM.puts 'dude'
	end
end

# verbosify
puts TTM.io.to_s

# done
puts '[done]'