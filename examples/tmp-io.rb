#!/usr/bin/ruby -w
require_relative './dir.rb'

# indent
TTM.indent('indent') do
	# before
	TTM.puts 'before'
	
	# tmp
	TTM.tmp_io(STDOUT) do
		TTM.puts 'during'
	end
	
	# after
	TTM.puts 'after'
end

# done
puts '[done]'