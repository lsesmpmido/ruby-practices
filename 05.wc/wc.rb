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

def contais_path(paths, file_info)
  if paths[0].empty?
    add_info($stdin.read, file_info)
  else
    paths.each { |path| add_info(File.read(path), file_info) }
  end
end

def add_info(content, file_info)
  file_info[:lines] << content.lines.size
  file_info[:words] << content.split(' ').size
  file_info[:bytes] << content.bytesize
end

def show_info(info, index, width, options = {})
  info.each_key do |key|
    print "#{info[key][index].to_s.rjust(width)} " if !options[key].nil? || options.empty?
  end
end

options = {}
file_info = { lines: [], words: [], bytes: [] }
total_info = { lines: [], words: [], bytes: [] }
paths = load_option(options).empty? ? [''] : load_option(options)
contais_path(paths, file_info)

file_info.each do |key, array|
  total_info[key] << array.sum
end
width = total_info.values.max[0].to_s.length
unless paths.size.equal?(1)
  file_info.each_key { |key| file_info[key].concat(total_info[key]) }
  paths << 'total'
end
paths.each_with_index do |path, index|
  show_info(file_info, index, width, options)
  puts path
end
