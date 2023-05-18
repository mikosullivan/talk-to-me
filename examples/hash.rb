#!/usr/bin/ruby -w
require_relative './dir.rb'

# big block string
speech = 'my speech'

# hash
hsh = {}
hsh['whatever'] = 'dude'
hsh['speech'] = speech

# show
TTM.show hsh

# done
puts '[done]'