#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

TTM.puts '[a]'

TTM.silent do
	TTM.puts '[b]'
end

TTM.puts '[c]'