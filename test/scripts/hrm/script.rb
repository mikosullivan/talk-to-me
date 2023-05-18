#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

def plain
	TTM.hrm
end

def block
	TTM.hrm do
		TTM.puts 'in block'
	end
end

plain()
block()