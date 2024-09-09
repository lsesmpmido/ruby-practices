#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def load_option(options)
  opts = OptionParser.new
  opts.on('-l', '--lines', 'print the newline counts') { options[:lines] = true }
  opts.on('-w', '--words', 'print the word counts') { options[:words] = true }
  opts.on('-c', '--bytes', 'print the byte counts') { options[:bytes] = true }
  opts.parse!(ARGV)
  ARGV
end

def add_info(content, file_info)
  file_info[:lines] << content.lines.size
  file_info[:words] << content.split(' ').size
  file_info[:bytes] << content.bytesize
end

options = {}
file_info = { lines: [], words: [], bytes: [] }
total_info = { lines: [], words: [], bytes: [] }
paths = load_option(options).empty? ? [''] : load_option(options)
paths.each { |path| add_info(File.read(path), file_info) }

file_info.each do |key, array|
  total_info[key] << array.sum
end
paths.each_with_index do |path, index|
  print "#{file_info[:lines][index].to_s.rjust(file_info[:lines].sum.to_s.size)} " if options[:lines] || options.empty?
  print "#{file_info[:words][index].to_s.rjust(file_info[:words].sum.to_s.size)} " if options[:words] || options.empty?
  print "#{file_info[:bytes][index].to_s.rjust(file_info[:bytes].sum.to_s.size)} " if options[:bytes] || options.empty?
  puts  path
end
print "#{total_info[:lines][0].to_s.rjust(total_info[:lines].sum.to_s.size)} " if options[:lines] || options.empty?
print "#{total_info[:words][0].to_s.rjust(total_info[:words].sum.to_s.size)} " if options[:words] || options.empty?
print "#{total_info[:bytes][0].to_s.rjust(total_info[:bytes].sum.to_s.size)} " if options[:bytes] || options.empty?
puts  "total"
