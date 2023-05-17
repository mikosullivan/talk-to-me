#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

# build hash
hsh = {}
hsh['first'] = 'Michael'
hsh['last'] = "O'Sullivan"
hsh['member'] = false
hsh['active'] = true

# show
TTM.show hsh