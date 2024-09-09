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

options = {}
file_info = { lines: [], words: [], bytes: [] }
paths = load_option(options).empty? ? [''] : load_option(options)

paths.each do |path|
  file_info[:lines] << File.read(path).lines.size
  file_info[:words] << File.read(path).split(' ').size
  file_info[:bytes] << File.read(path).bytesize
end

paths.each_with_index do |path, index|
  print "#{file_info[:lines][index].to_s.rjust(file_info[:lines].sum.to_s.size)} " if options[:lines] || options.empty?
  print "#{file_info[:words][index].to_s.rjust(file_info[:words].sum.to_s.size)} " if options[:words] || options.empty?
  print "#{file_info[:bytes][index].to_s.rjust(file_info[:bytes].sum.to_s.size)} " if options[:bytes] || options.empty?
  puts  path
end
puts "#{file_info[:lines].sum} #{file_info[:words].sum} #{file_info[:bytes].sum} total" unless paths.size.equal?(1)
