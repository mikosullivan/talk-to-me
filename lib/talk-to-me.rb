#===============================================================================
# TTM
#
module TTM
	# initialize indent to 0
	@indent = 0
	
	
	#---------------------------------------------------------------------------
	# io
	#
	@io = nil
	
	def self.io=(handle)
		return @io = handle
	end
	
	def self.io
		return @io
	end
	#
	# out
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# tab
	#
	@tab = '  '
	
	def tab
		return @tab
	end
	
	def tab=(p_tab)
		return @tab = p_tab
	end
	#
	# tab
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# puts
	#
	def self.puts(*opts)
		@io or return
		lead = @tab * @indent
		vals = []
		
		# build string values
		opts.each do |opt|
			vals.push object_display_string(opt)
		end
		
		# loop through strings
		effective_io() do |use_io|
			vals.join('').lines.each do |line|
				line = lead + line
				use_io.puts line
			end
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
	# effective_io
	# Determines if @io is an IO object or a string. If it's a string, opens a
	# file at that path, locks the file, yields the file IO, then closes the
	# file. If @io is already and IO object, yield that.
	#
	def self.effective_io()
		# IO
		if @io.is_a?(IO)
			yield @io
		
		# TTM::Cache
		elsif @io.is_a?(TTM::Cache)	
			yield @io
			
		# If @io is a string, use that as the path to a file to which to output.
		elsif @io.is_a?(String)
			File.open(@io, 'a+') do |file_io|
				file_io.flock File::LOCK_EX
				file_io.seek 0, IO::SEEK_END
				
				begin
					yield file_io
				ensure
					file_io.flock File::LOCK_UN
				end
			end
		
		# else don't know object class, so throw error
		else
			raise 'unknown-io: ' + @io.class.to_s
		end
	end
	#
	# effective_io
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# clear
	# If @io is an IO, this method does nothing. If @io is a String, deletes the
	# file at that path if it exists. This method never throws an exception.
	# 
	# KLUDGE: This method is a little sloppy. It doesn't deal with race
	# conditions. It just attempts to delete the file and does nothing on an
	# error.
	#
	def self.clear
		if @io.is_a?(String)
			begin
				File.delete @io
			rescue
			end
		end
	end
	#
	# clear
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# indent
	#
	def self.indent(*opts)
		opts = opts_to_hash(*opts)
		
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
	def self.silent(&block)
		tmp_io nil, &block
	end
	#
	# silent
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# show
	#
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
	def self.line(*opts)
		@io or return
		opts = opts_to_hash(*opts)
		opts = {'stack'=>0}.merge(opts)
		
		# get caller location
		loc = caller_locations()[opts['stack']]
		
		# initialize output string
		out = "[#{loc.lineno} #{File.basename(loc.path)}"
		
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
	def self.json(obj, opts={})
		@io or return
		
		hr do
			return self.puts(JSON.pretty_generate(obj))
		end
	end
	#
	# json
	#---------------------------------------------------------------------------
	
	
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
			return 'nil'
		
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
module TTM::HR
	#---------------------------------------------------------------------------
	# puts
	#
	def self.puts(opts=nil, &block)
		opts = parse_opts(opts)
		dash = opts['dash']
		
		# output with title or plain
		if opts['title']
			out = dash * 3
			out += ' '
			out += opts['title']
			out += ' '
			out += dash * (width - out.length)
			TTM.puts out
		else
			TTM.puts dash * width
		end
		
		# if block given, yield and output another hr
		if block_given?
			begin
				yield
			ensure
				TTM.puts dash * width
			end
		end
		
		# always return nil
		return nil
	end
	#
	# puts
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# width
	# Eventually this method will determine how wide a horizontal rule should be
	# based on terminal width and indentation. Someday.
	#
	def self.width
		return 50
	end
	#
	# width
	#---------------------------------------------------------------------------

	
	#---------------------------------------------------------------------------
	# parse_opts
	#
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
module TTM::Show
	#---------------------------------------------------------------------------
	# show
	#
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
	# show
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# show_array
	#
	def self.show_array(myarr, opts)
		showarr_simple myarr, opts
	end
	#
	# show_array
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# showarr_simple
	#
	def self.showarr_simple(myarr, opts)
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
	# showarr_simple
	#---------------------------------------------------------------------------
	
	
	#---------------------------------------------------------------------------
	# show_hash
	#
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
					val = val.to_s
					
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
# TTM::Cache
#
class TTM::Cache
	attr_reader :strs
	
	# initialize
	def initialize
		@strs = []
	end
	
	# puts
	def puts(str)
		@strs.push str + "\n"
	end
	
	# to_s
	def to_s
		return @strs.join('')
	end
end
#
# TTM::Cache
#===============================================================================