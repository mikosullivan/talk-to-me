#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = STDOUT

TTM.tab = '         '

TTM.indent('[a]') do
	TTM.puts '[b]'
end

TTM.puts '[c]'
