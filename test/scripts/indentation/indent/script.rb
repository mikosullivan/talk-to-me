#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

TTM.puts '[a]'

TTM.indent('[b]') do
	TTM.indent('[c]') do
		TTM.puts '[d]'
	end
	
	TTM.puts '[e]'
end

TTM.puts '[f]'