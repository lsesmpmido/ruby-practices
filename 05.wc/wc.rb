#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

options = {}
lines = []
words = []
sizes = []

opts = OptionParser.new
opts.on('-l', '--lines', 'print the newline counts') { options[:lines] = true }
opts.on('-w', '--words', 'print the word counts') { options[:words] = true }
opts.on('-c', '--bytes', 'print the byte counts') { options[:bytes] = true }
opts.parse!(ARGV)
paths = ARGV

paths.each do |path|
  lines << File.read(path).lines.size
  words << File.read(path).split(' ').size
  sizes << File.open(path).size
end

paths.each_with_index do |path, index|
  print "#{lines[index].to_s.rjust(lines.sum.to_s.size)} " if options[:lines] || options.empty?
  print "#{words[index].to_s.rjust(words.sum.to_s.size)} " if options[:words] || options.empty?
  print "#{sizes[index].to_s.rjust(sizes.sum.to_s.size)} " if options[:bytes] || options.empty?
  puts  path
end
puts "#{lines.sum} #{words.sum} #{sizes.sum} total" unless paths.size.equal?(1)
