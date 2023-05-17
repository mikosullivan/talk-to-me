require 'minitest/autorun'
require 'open3'
Dir.chdir File.dirname(__FILE__)

# test class
class TTMTest < Minitest::Test
	# run the script and capture its output
	def capture(dir)
		Dir.chdir("scripts/#{dir}") do
			return TTMTest::Capture.new('./script.rb')
		end
	end
	
	# slurp in should.txt
	def should(dir)
		Dir.chdir("scripts/#{dir}") do
			return TTMTest::Capture.new('./script.rb')
		end
	end
	
	# by default, TTM shouldn't output anything
	def test_nil
		dir = 'nil'
		cpt = capture(dir)
		refute cpt.stdout.match(/\S/mu)
	end
end

# class for capturing the output of a script
class TTMTest::Capture
	# initialize
	def initialize(*cmd)
		@results = Open3.capture3(*cmd)
	end
	
	# stdout
	def stdout
		return @results[0]
	end
	
	# stderr
	def stderr
		return @results[1]
	end
end