#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'talk-to-me'
TTM.io = STDOUT

TTM.puts '[a]'

TTM.indent do
	line = "[b]\n[c]\n[d]"
	TTM.puts line
end

TTM.puts '[e]'

TTM.hr

TTM.puts nil
TTM.puts ''
TTM.puts '   '

# done
puts '[done]'