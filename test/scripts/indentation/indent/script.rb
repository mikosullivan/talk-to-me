#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = STDOUT

TTM.puts '[a]'

TTM.indent('[b]') do
	TTM.indent('[c]') do
		TTM.puts '[d]'
	end
	
	TTM.puts '[e]'
end

TTM.puts '[f]'
