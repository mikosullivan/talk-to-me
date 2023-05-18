#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'tatum'
TTM.io = STDOUT


# hsh
hsh = {
	'whatever' => 'dude',
	'people' => [
		'Joe',
		'Mekonnan',
		''
	],
	
	'status' => nil
};

TTM.show hsh

arr = %w{a b c}
TTM.show arr
