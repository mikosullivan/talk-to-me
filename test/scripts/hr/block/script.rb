#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

# HR with text
TTM.hr('whatever') do
	TTM.indent do
		TTM.hr 'nested'
	end
end