#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'tatum'
TTM.io = STDOUT

TTM.puts '[a]'

TTM.silent do
	TTM.puts '[b]'
end

TTM.puts '[c]'
