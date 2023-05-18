#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = STDOUT

# standard HR
TTM.hr

# set width to 100
TTM.hr_width = 100
TTM.hr
