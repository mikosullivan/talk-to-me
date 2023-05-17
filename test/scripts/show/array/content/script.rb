#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

# build array
arr = []
arr.push 'whatever'
arr.push nil
arr.push 1
arr.push true

# show
TTM.show arr