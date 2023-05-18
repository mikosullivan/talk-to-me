#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'talk-to-me'

# generate random file name
path = rand().to_s
path = path.sub(/\A0\./mu, '')
path = "/tmp/#{path}.txt"

# set output path
TTM.io = path

# output to file
TTM.puts '[a]'

# clear
TTM.clear

# output path
STDOUT.puts path