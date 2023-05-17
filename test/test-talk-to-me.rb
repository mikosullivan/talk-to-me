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
	
	# compare
	def compare(dir)
		cpt = capture(dir)
		assert_equal cpt.stdout, should(dir)
	end
	
	# by default, TTM shouldn't output anything
	def test_nil
		dir = 'handles/nil'
		cpt = capture(dir)
		refute cpt.stdout.match(/\S/mu)
	end
	
	# stdout
	def test_stdout
		dir = 'handles/stdout'
		compare dir
	end
	
	# stderr
	def test_stderr
		dir = 'handles/stderr'
		cpt = capture(dir)
		assert_equal cpt.stderr, should(dir)
	end
	
	# output to file
	# TODO: Need to learn how to issue a warning if this test can't be run.
	def test_file
		if File.exist?('/tmp')
			dir = 'handles/file'
			cpt = capture(dir)
			path = cpt.stdout
			content = File.read(path).rstrip
			assert_equal content, should(dir)
			
			# delete tmp file, but don't bother dealing with an error
			begin
				File.delete path
			rescue
			end
		end
	end
	
	# string
	def test_string
		dir = 'handles/string'
		compare dir
	end
	
	# indent
	def test_indent
		compare 'indent'
	end
	
	# display-string
	def test_display_string
		compare 'display-string'
	end
	
	# show
	def test_show
		compare 'show/hash/empty'
		compare 'show/hash/content'
		compare 'show/array/empty'
		compare 'show/array/content'
	end
end

# class for capturing the output of a script
class TTMTest::Capture
	def initialize(*cmd)
		@results = Open3.capture3(*cmd)
	end
	
	def stdout
		return @results[0].rstrip
	end
	
	def stderr
		return @results[1].rstrip
	end
end