#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = TTM::Memory
TTM.puts '[a]'
TTM.puts '[b]'
TTM.puts '[c]'
TTM.puts '[d]'
STDOUT.puts TTM.io.to_s
