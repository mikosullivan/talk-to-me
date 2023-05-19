#!/usr/bin/ruby -w
require_relative '../dir.rb'
require 'tatum'
TTM.io = STDOUT

TTM.line
TTM.line 'whatever'
TTM.devexit 'whatever'