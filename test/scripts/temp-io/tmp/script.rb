#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = STDOUT

TTM.indent('[a]') do
	TTM.puts '[stuff sent to STDOUT]'
	
	TTM.tmp_io(STDERR) do
		TTM.puts '[stuff sent to STDERR]'
	end
	
	TTM.puts '[more stuff sent to STDOUT]'
end
