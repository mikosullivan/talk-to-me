#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'
TTM.io = STDOUT

# standard HR
TTM.hr

# set width to 100
TTM.hr_width = 100
TTM.hr