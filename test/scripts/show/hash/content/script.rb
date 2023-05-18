#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = STDOUT

# build hash
hsh = {
	'string' => 'dude',
	
	'nil' => nil,
	
	'empty-string' => '',
	
	'no-content-string' => '   ',
	
	'array' => [
		'Joe',
		'Mekonnan'
	]
};

# show
TTM.show hsh
