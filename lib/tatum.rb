#===============================================================================
# TTM
#
module TTM
	# initialize attributes
	@indent = 0
	@io = nil
	@hr_width = 50
	@tab = '  '
	
	
	#---------------------------------------------------------------------------
	# accessors
	#
	
	# Returns @io
	def self.io
		return @io
	end
	
	# Sets the output handle. Usually you'll want to set the handle to STDOUT or
	# STDERR. If the given io is a string, it's assumed to be the path to a file
	# to write to. To write to a string in memory, send TTM::Memory.
	# 
	# If a Class object is sent, then the class is instantiated with the p_io
	# as the param for new(). That class will have to provide the #puts method.
	def self.io=(p_io)
		# special case: if p_io is a string, instantiate a TTM::File object.
		if p_io.is_a?(String)
			return @io = TTM::File.new(p_io)
			
		# if the given object is a class, instantiate it
		elsif p_io.is_a?(Class)
			return @io = p_io.new(p_io)
		
		# else just hold on to the handle
		else
			return @io = p_io
		end
	end
	
	# Returns width of horizontal rule.
	# @return [Int]
	def self.hr_width
		return @hr_width
	end
	
	# Sets width of horizontal rule.
	# @param [Int] p_width
	# @return [Int]
	def self.hr_width=(p_width)
		return @hr_width = p_width
	end
	
	# Returns the string used for indentation.
	# 
	# @return [String]
	def self.tab
		return @tab
	end
	
	# Sets the tab used for indentation
	# 
	#    TTM.tab = '         '
	#    
	#    TTM.indent('[a]') do
	#       TTM.puts '[b]'
	#    end
	#    
	#    TTM.puts '[c]'
	#    
	# outputs:
	#    
	#    [a]
	#             [b]
	#    [c]
	#
	# @param [String] p_tab
	# @return [String]
	def self.tab=(p_tab)
		return @tab = p_tab
	end
	
	#
	# accessors
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# puts
	#
	
	# Outputs a stringification of the given object, indented if necessary.
	#
	#    TTM.puts '[a]'
	#    
	#    TTM.indent do
	#       line = "[b]\n[c]\n[d]"
	#       TTM.puts line
	#    end
	#    
	#    TTM.puts '[e]'
	#    
	# outputs:
	#    
	#    [a]
	#      [b]
	#      [c]
	#      [d]
	#    [e]
	#
	# Some objects are represented by strings in brackets instead of their
	# to_s values. This is to make it easier to see what typew of objects they
	# are.
	#
	#    TTM.puts nil
	#    TTM.puts ''
	#    TTM.puts '   '
	#    
	# outputs:
	#    
	#    [nil]
	#    [empty-string]
	#    [no-content-string]
	
	def self.puts(*opts)
		@io or return
		lead = @tab * @indent
		vals = []
		
		# build string values
		opts.each do |opt|
			vals.push object_display_string(opt)
		end
		
		# loop through strings
		vals.join('').lines.each do |line|
			line = lead + line
			@io.puts line
		end
	
		
		# Always return nil to avoid confusion when this method is the last line
		# in a function and the return value of the function is used for
		# something.
		return nil
	end
	#
	# puts
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# clear
	# 
	
	# Clears the output handle. If @io is STDOUT or STDERR, this method does
	# nothing. If @io is a String, deletes the file at that path if it exists.
	# If @io is any other object that responds to #clear then that method is
	# called.
	#
	# @return [nil]
	def self.clear
		if @io.respond_to?('clear')
			@io.clear
		end
	end
	#
	# clear
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# indent
	#
	
	# Sets an indentation level. Output within the do block is indented. Takes
	# an optional string.
	#
	#   TTM.indent('whatever') do
	#      TTM.puts 'dude'
	#   end
	#
	# outputs:
	#
	#   whatever
	#     dude
	
	def self.indent(*opts)
		opts = opts_to_hash(*opts)
		
		# output header if one was sent
		if opts['str']
			puts opts['str']
		end
		
		# if block given, temporarily set indent, then revert
		if block_given?
			hold_indent = @indent
			
			unless opts['skip']
				@indent += 1
			end
			
			begin
				yield
			ensure
				@indent = hold_indent
			end
			
		# else just set indent
		else
			@indent += 1
		end
	end
	#
	# indent
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# tmp_io
	#
	
	# Temporarily sends output to a different output target in the do block.
	#
	#    TTM.indent('[a]') do
	#       TTM.puts '[stuff sent to STDOUT]'
	#       
	#       TTM.tmp_io(STDERR) do
	#          TTM.puts '[stuff sent to STDERR]'
	#       end
	#       
	#       TTM.puts '[more stuff sent to STDOUT]'
	#    end
	#    
	# This code outputs this to STDOUT:
	#    
	#    [a]
	#      [stuff sent to STDOUT]
	#      [more stuff sent to STDOUT]
	#    
	# And this to STDERR. Notice that indentation is reset to 0 during the temporary
	# redirect.
	#    
	#    [stuff sent to STDERR]
	
	def self.tmp_io(p_io, &block)
		io_hold = @io
		@io = p_io
		hold_indent = @indent
		@indent = 0
		yield
	ensure
		@indent = hold_indent
		@io = io_hold
	end
	#
	# silent
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# silent
	#
	
	# Temporarily turns off output.
	#
	#    TTM.puts '[a]'
	#    
	#    TTM.silent do
	#       TTM.puts '[b]'
	#    end
	#    
	#    TTM.puts '[c]'
	#    
	# outputs:
	#    
	#    [a]
	#    [c]
	
	def self.silent(&block)
		tmp_io nil, &block
	end
	#
	# silent
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# show
	#
	
	# TTM.show outputs a visual representation of a hash or an array.
	#
	#    hsh = {
	#       'whatever' => 'dude',
	#       'people' => [
	#          'Joe',
	#          'Mekonnan',
	#          ''
	#       ],
	#       
	#       'status' => nil
	#    };
	#    
	#    TTM.show hsh
	#    
	#    arr = %w{a b c}
	#    TTM.show arr
	#    
	# outputs:
	#    
	#    +----------+---------------------+
	#    | people   | [Joe | Mekonnan | ] |
	#    | status   | [nil]               |
	#    | whatever | dude                |
	#    +----------+---------------------+
	#    --------------------------------------------------
	#    a
	#    b
	#    c
	#    --------------------------------------------------
	
	def self.show(obj)
		@io or return
		return TTM::Show.puts obj
	end
	#
	# show
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# hr
	#
	
	# Outputs a horizontal rule.
	#   TTM.hr
	#
	# gives us this:
	#   --------------------------------------------------
	#
	# If you pass in a string, that string is embedded in the horizontal rule.
	#   TTM.hr 'whatever'
	# gives us this:
	#   --- whatever -------------------------------------
	#
	# TTM.hr takes a block param. If a block is sent, then a horizontal rule is
	# output before and after the block:
	# 
	#   TTM.hr do
	#       puts 'do stuff'
	#   end
	#
	# gives us this:
	#
	#   --------------------------------------------------
	#   do stuff
	#   --------------------------------------------------
	#
	# You can combine sending a string and a block:
	#
	#   TTM.hr('whatever') do
	#       puts 'do stuff'
	#   end
	#
	# output:
	#
	#   --- whatever -------------------------------------
	#   do stuff
	#   --------------------------------------------------
	#
	# == opts as hash
	# 
	# Options can be passed in as a hash. Behind the scenes, if you pass in a
	# string then it is converted to a hash like this:
	# 
	#   {'title'=>'whatever'}
	#
	# So these two commands do exactly the same thing:
	#
	#   TTM.hr 'whatever'
	#   TTM.hr 'title'=>'whatever'
	#
	# === dash
	#
	# The dash option indicates what character to use for the dashes in the
	# horizontal rule.
	#
	#   TTM.hr 'title'=>'whatever', 'dash'=>'='
	#
	# output:
	#
	#   === whatever =====================================
	
	def self.hr(opts=nil, &block)
		@io or return
		return TTM::HR.puts opts, &block
	end
	#
	# hr
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# hrm
	#
	
	# Outputs the name of the current method in a horizontal rule.
	#
	#   def mymethod
	#     TTM.hrm
	#   end
	#
	#   mymethod()
	#
	# outputs:
	#
	#   --- mymethod -------------------------------------
	#
	# TTM.hrm accepts a do block:
	# 
	#   def mymethod
	#      TTM.hrm do
	#         puts 'stuff about mymethod'
	#      end
	#   end
	#
	# outputs:
	#
	#   --- mymethod -------------------------------------
	#   stuff about mymethod
	#   --------------------------------------------------
	
	def self.hrm(*opts)
		lbl = caller_locations(1,1)[0].label
		
		if opts[0]
			lbl += ': ' + opts[0].to_s
		end
		
		# block or straight
		if block_given?
			self.hr(lbl) do
				yield
			end
		else
			self.hr lbl
		end
	end
	#
	# hrm
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# line
	
	# Outputs the number and file name of the line this method is called from.
	# Also outputs a given string if one is sent.
	#
	#    TTM.line 'whatever'
	#    
	# outputs:
	#    
	#    [6 myfile.rb] whatever
	
	def self.line(*opts)
		@io or return
		opts = opts_to_hash(*opts)
		opts = {'stack'=>0}.merge(opts)
		
		# get caller location
		loc = caller_locations()[opts['stack']]
		
		# initialize output string
		out = "[#{loc.lineno} #{::File.basename(loc.path)}"
		
		# add included string if sent
		if opts['include']
			out += ' ' + opts['include']
		end
		
		# close brackets
		out += ']'
		
		# add str if sent
		if opts['str']
			out += ' ' + opts['str']
		end
		
		# output
		return self.puts(out)
	end
	#
	# line
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# devexit
	#
	
	# Outputs "[devexit]" and exits. This method is handy is testing for when
	# you want to exit the program, but make it clear that you did so in a
	# developmentish way.
	# @return [nothing]
	def self.devexit(*opts)
		opts = opts_to_hash(*opts)
		opts = {'include'=>'devexit', 'stack'=>1}.merge(opts)
		self.line opts
		exit
	end
	#
	# devexit
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# json
	#
	
	# Outputs a given structure in JSON format;
	# 
	#    hsh = {
	#       'whatever' => 'dude',
	#       'people' => [
	#          'Joe',
	#          'Mekonnan',
	#          'AJ'
	#       ]
	#    };
	#    
	#    TTM.json hsh
	#    
	# outputs
	#    
	#    --------------------------------------------------
	#    {
	#      "whatever": "dude",
	#      "people": [
	#        "Joe",
	#        "Mekonnan",
	#        "AJ"
	#      ]
	#    }
	#    --------------------------------------------------
	
	def self.json(obj, opts={})
		@io or return
		require 'json'
		
		hr do
			return self.puts(::JSON.pretty_generate(obj))
		end
	end
	#
	# json
	#---------------------------------------------------------------------------
	
	
	# private
	private	
	
	#---------------------------------------------------------------------------
	# opts_to_hash
	# Figures out if the given opts are nil, a string, or a hash. Always returns
	# a hash.
	# 
	# Remember, *opts is always an array.
	# 
	# If empty array, return empty hash.
	# 
	# Get first element
	# 	If hash, return that
	# 	Everything else, return a hash with a stringification of that first
	# 	object.
	#
	def self.opts_to_hash(*opts)
		# if opts is empty, return an empty hash
		if opts.empty?
			return {}
		end
		
		# first element is all we care about
		el = opts[0]
		
		# if opts is a hash, return that
		if el.is_a?(Hash)
			return opts[0]
		end
		
		# everything else, return stringified object as "str" element in hash
		return {'str'=>object_display_string(el)}
	end
	#
	# opts_to_hash
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# object_display_string
	# Returns a human readable representation of an object. Note that this
	# method is basically a shiny gloss over to_s. Don't confuse this method
	# with showing a hash or array.
	#
	def self.object_display_string(obj)
		# nil
		if obj.nil?
			return '[nil]'
		
		# string values
		elsif obj.is_a?(String)
			if obj.match(/\S/mu)
				return obj
			elsif obj.empty?
				return '[empty-string]'
			else
				return '[no-content-string]'
			end
		
		# else return stringification of object
		else
			return obj.to_s
		end
	end
	#
	# object_display_string
	#---------------------------------------------------------------------------
end
#
# TTM
#===============================================================================


#===============================================================================
# TTM::HR
#

# Handles building horizontal rules.

module TTM::HR
	#---------------------------------------------------------------------------
	# puts
	#
	
	# Builds and outputs a horizontal rule. See TTM.hr for details.
	
	def self.puts(opts=nil, &block)
		opts = parse_opts(opts)
		dash = opts['dash']
		
		# output with title or plain
		if opts['title']
			out = dash * 3
			out += ' '
			out += opts['title']
			out += ' '
			out += dash * (TTM.hr_width - out.length)
			TTM.puts out
		else
			TTM.puts dash * TTM.hr_width
		end
		
		# if block given, yield and output another hr
		if block_given?
			begin
				yield
			ensure
				TTM.puts dash * TTM.hr_width
			end
		end
		
		# always return nil
		return nil
	end
	#
	# puts
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# parse_opts
	#
	
	# Parses the options sent to .puts
	
	def self.parse_opts(opts=nil)
		# default
		default = {'dash'=>'-'}
		
		# nil
		if opts.nil?
			return default
		end
		
		# if opts is not a hash, use that object as the title
		if not opts.is_a?(Hash)
			opts = {'title'=>opts.to_s}
		end
		
		# merge into default
		opts = default.merge(opts)
		
		# return
		return opts
	end
	#
	# parse_opts
	#---------------------------------------------------------------------------
end
#
# TTM::HR
#===============================================================================


#===============================================================================
# TTM::Show
#

# Builds the string representation of the given object. See TTM.show for
# details.

module TTM::Show
	#---------------------------------------------------------------------------
	# puts
	#
	
	# Determines the class of the given object and outputs a string
	# representation of it using TTM.puts.
	
	def self.puts(obj, opts={})
		# nil
		if obj.nil?
			TTM.puts '[nil]'
		
		# hash
		elsif obj.is_a?(Hash)
			show_hash obj, opts
		
		# array
		elsif obj.is_a?(Array)
			show_array obj, opts
			
		# else just output
		else
			TTM.puts obj.to_s
		end
		
		# always return nil
		return nil
	end
	#
	# puts
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# show_array
	#
	
	# Outputs a string representation of each object in the array. Puts the
	# output inside horizontal rules.
	
	def self.show_array(myarr, opts)
		# if empty
		if myarr.empty?
			TTM.puts '[empty array]'
			
			# else there's stuff in the array
		else
			TTM.hr do
				myarr.each do |el|
					TTM.puts el
				end
			end
		end
	end
	#
	# show_array
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# show_hash
	#
	
	# Outputs a hash as a text table.
	
	def self.show_hash(hsh, opts)
		opts = {'sort'=>true}.merge(opts)
		
		# if empty, output string indicating so
		if hsh.empty?
			TTM.puts '[empty hash]'
			
		# else display hash as a table
		else
			require 'text-table'
			
			# table object
			table = Text::Table.new
			
			# get array of keys
			keys = hsh.keys
			
			# sort if necessary
			if opts['sort']
				keys.sort!{|a,b| a.to_s.downcase <=> b.to_s.downcase}
			end
			
			# loop through keys
			keys.each do |k|
				# get value
				val = hsh[k]
				
				# if val is a hash, show a list of hash keys
				if val.is_a?(Hash)
					val = val.keys.sort{|a,b| a.to_s <=> b.to_s}
					val = val.map{|vk| vk.to_s}
					val = '{' + val.join(', ') + '}'
					
				# if array, join elements
				elsif val.is_a?(Array)
					val = val.map{|vk| vk.to_s}
					val = '[' + val.join(' | ') + ']'
					
				# trim value display
				else
					# val = val.to_s
					val = TTM.object_display_string(val)
					
					if val.length > 120
						val = val[0..117] + '...'
					end
				end
				
				# add to table
				table.rows.push [k, val]
			end
			
			# output
			TTM.puts table.to_s
		end
	end
	#
	# show_hash
	#---------------------------------------------------------------------------
end
#
# TTM::Show
#===============================================================================


#===============================================================================
# TTM::Memory
#
class TTM::Memory
	# Returns the array used to store output strings. You probably don't need
	# this method for anything; it's just handy for debugging.
	# @return [Array]
	attr_reader :str
	
	# Initializes the Memory object. Doesn't actually do anything with the
	# p_path param, but sending that param is the standard for any class that
	# can be used with TTM.io.
	def initialize(p_path)
		clear()
	end
	
	# Adds a string to @strs.
	# @param [String] str
	def puts(str)
		@str += str + "\n"
	end
	
	# Returns the string that is stored in memory.
	# @return [String]
	def to_s
		return @str
	end
	
	# Resets @str to an empty string.
	def clear
		@str = ''
	end
end
#
# TTM::Memory
#===============================================================================


#===============================================================================
# TTM::File
#

# Outputs to a file.

class TTM::File
	# The path to the file.
	# @return [String]
	attr_reader :path
	
	# Initializes the object. Stores p_path into @path.
	# @param [String] p_path
	def initialize(p_path)
		@path = p_path
	end
	
	# Outputs the given string to the file. Every call to #puts opens the file,
	# locks it, and appends the string to the end of the file.
	# @param [String] str
	# @return [Nil]
	def puts(str)
		File.open(@path, 'a+') do |file_io|
			file_io.flock File::LOCK_EX
			file_io.seek 0, IO::SEEK_END
			
			begin
				file_io.puts str
			ensure
				file_io.flock File::LOCK_UN
			end
		end
	end
	
	# Reads the file and returns its content. If the file doesn't exist then an
	# empty string is returned.
	# @return [String]
	def to_s
		if File.exist?(@path)
			return File.read(@path)
		else
			return ''
		end
	end
	
	# Deletes the ouput file.
	# @return [Nil]
	def clear
		begin
			File.delete @path
		rescue
		end
		
		return nil
	end
end
#
# TTM::File
#===============================================================================