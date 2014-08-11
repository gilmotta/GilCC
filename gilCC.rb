# GilCC GCC Colorize Shell - colorizes the output from GCC compiler
# Copyright (C) 2014  Gilson Motta - Only Solutions Software LLC.
#
# Licensed under the MIT
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

# About gilCC - 
# Non intrusive C compiler Colorize shell works with any GCC version. An excellent option
# if you cannot upgrade your GCC compiler to version 4.9 but still want to add color
# to the output.
#
# Dependencies:
# This program depends on Ruby to work. Only tested with Ruby 2.0.0
#
	
require 'colorize'
require 'benchmark'

# Globals
$no_of_warnings = 0
$no_of_errors = 0

# set the default command line for compiler
# for example:
# "gcc -g0 -d3 myfile.c" - you are calling gcc directly so your default command compiler is just 'gcc'
# "make arg1 arg2 arg3" - you are calling gcc via makefile so your default command compiler is just 'make' 
default_cmd_line_compiler = "make"

# set the default command line here i.e. when you call gilCC without arguments it will
# call your default_cmd_line_compiler and pass the arguments below.
default_cmd_line_args = "clean ndebug"

# please support Free Open Source initiative by not removing copyright disclaimer
# all the author is asking is credit to his work and if you improve the code share with the community.
# thanks for using gilCC
puts "GilCC GCC Colorize Shell version 1.0".cyan
puts "Copyright (C) 2014 Only Solutions Software LLC www.onlysolutionssoftware.com".cyan

#
# Color usage rules:
#	1. use cyan for gilCC messages and information to the user and Ruby code exceptions
#	2. white, green, yellow and red is reserved for the compiler output
#	3. blue and magenta can be anything for example debugging
#

cmd_line = ""

# build command line based on command line input or just use the default
if( ARGV.size>0 )
	ARGV.each do|a|
	  cmd_line = cmd_line + a + " "
	end
	cmd_line = default_cmd_line_compiler + " " + cmd_line
else
	cmd_line = default_cmd_line_compiler + " " + default_cmd_line_args
end

# show the command line to the user
puts
puts cmd_line.magenta

time = Benchmark.realtime{
	# read output from compiler and look for warnings and errors
	output = %x[#{cmd_line + " 2>&1"}]
	output.split(/\r?\n|\r/).each { |line|
		str = line 
		if str.downcase.include? "warning:"
			puts str.colorize( :black ).colorize( :background => :yellow )
			puts
			$no_of_warnings += 1 
		elsif str.downcase.include? "in function" 
			puts
			puts str.bold
		elsif str.downcase.include? "error:"
			puts ("-" * str.length).colorize( :white ).colorize( :background => :red )
			puts str.colorize( :white ).colorize( :background => :red )
			puts ("-" * str.length).colorize( :white ).colorize( :background => :red )
			$no_of_errors += 1
		elsif str.include? " Error "
			puts ("-" * str.length).colorize( :white ).colorize( :background => :red )
			puts str.colorize( :white ).colorize( :background => :red )
			puts ("-" * str.length).colorize( :white ).colorize( :background => :red )
			$no_of_errors += 1		
		else
			puts str.green
		end
	}
}

# show our statistics to the user
puts
puts " Build Statistics".cyan.swap + (" " * (" Compile time: #{time} seconds".length - " Build Statistics".length)).cyan.swap
puts (" Warnings: " + $no_of_warnings.to_s + (" " * (" Compile time: #{time} seconds".length - " Warnings: ".length -  $no_of_warnings.to_s.length))).cyan.swap
puts (" Errors: " + $no_of_errors.to_s + (" " * (" Compile time: #{time} seconds".length - " Errors: ".length -  $no_of_errors.to_s.length))).cyan.swap
puts " Compile time: #{time} seconds".cyan.swap