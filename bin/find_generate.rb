#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__), "..", 'lib')))
require 'easy_find'

if ARGV.length == 0
  str = ''
  while $stdin.gets
    str << $_
  end
  puts eval str
elsif ARGV.length == 1
  contents = open(ARGV[0]).read
  puts eval contents
else
  puts "Wrong number of arguments"
end

