#!/usr/bin/ruby -w
require_relative '/home/miko/projects/ruby-lib/content/lib/cl-dev.rb'
require 'talk-to-me'
TTM.io = STDOUT

# hsh
hsh = {
	'whatever' => 'dude',
	'people' => [
		'Joe',
		'Mekonnan',
		'AJ'
	]
};

TTM.json hsh