#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

TTM.tab = '         '

TTM.indent('[a]') do
	TTM.puts '[b]'
end

TTM.puts '[c]'