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
			return File.read('./should.txt').rstrip
		end
	end
	
	# by default, TTM shouldn't output anything
	def test_nil
		dir = 'nil'
		cpt = capture(dir)
		refute cpt.stdout.match(/\S/mu)
	end
	
	# simple stdout test
	def test_stdout
		dir = 'stdout'
		cpt = capture(dir)
		assert_equal cpt.stdout.rstrip, should(dir).rstrip
	end
	
	# simple stderr test
	def test_stderr
		dir = 'stderr'
		cpt = capture(dir)
		assert_equal cpt.stderr.rstrip, should(dir)
	end
end

# class for capturing the output of a script
class TTMTest::Capture
	def initialize(*cmd)
		@results = Open3.capture3(*cmd)
	end
	
	def stdout
		return @results[0]
	end
	
	def stderr
		return @results[1]
	end
end