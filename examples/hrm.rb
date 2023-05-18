#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'talk-to-me'
TTM.io = STDOUT

# code
def mymethod
	TTM.hrm do
		puts 'stuff about mymethod'
	end
end

mymethod()