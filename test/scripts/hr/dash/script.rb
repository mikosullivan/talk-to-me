#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

# HR with alternate dashes
TTM.hr('title'=>'whatever', 'dash'=>'=') do
	puts 'do stuff'
end