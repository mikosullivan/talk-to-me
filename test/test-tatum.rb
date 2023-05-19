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
	def should(dir, opts={})
		opts = {'file'=>'should.txt'}.merge(opts)
		
		Dir.chdir("scripts/#{dir}") do
			
			
			return File.read("./#{opts['file']}").rstrip
		end
	end
	
	# compare
	def compare(dir, opts={})
		cpt = capture(dir)
		
		# KLUDGE: assert_equal is finding a difference in show/hash/content, so
		# doing a string comparison
		assert cpt.stdout == should(dir)
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
	
	# clear file
	# TODO: Need to learn how to issue a warning if this test can't be run.
	def test_clear_file
		if File.exist?('/tmp')
			dir = 'clear/file'
			cpt = capture(dir)
			refute File.exist?(cpt.stdout)
		end
	end
	
	# clear memory
	def test_clear_memory
		compare 'clear/memory'
	end
	
	# memory
	def test_memory
		dir = 'handles/memory'
		compare dir
	end
	
	# indent
	def test_indent
		compare 'indentation/indent'
		compare 'indentation/tab'
	end
	
	# display-string
	def test_display_string
		compare 'display-string'
	end
	
	# hrm
	def test_hrm
		compare 'hrm'
	end
	
	# hr
	def test_hr
		compare 'hr/plain'
		compare 'hr/text'
		compare 'hr/block'
		compare 'hr/dash'
	end
	
	# show
	def test_show
		compare 'show/hash/empty'
		compare 'show/hash/content'
		compare 'show/array/empty'
		compare 'show/array/content'
	end
	
	# silent
	def test_silent
		compare 'temp-io/silent'
	end
	
	# temp_io
	def test_temp_io
		dir = 'temp-io/tmp'
		cpt = capture(dir)
		assert_equal should(dir, 'file'=>'stdout.txt'), cpt.stdout
		assert_equal should(dir, 'file'=>'stderr.txt'), cpt.stderr
	end
	
	# line
	def test_line
		compare 'line'
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