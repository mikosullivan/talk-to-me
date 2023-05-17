#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

# build hash
hsh = {}

# show
TTM.show hsh