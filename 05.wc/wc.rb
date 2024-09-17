#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = {}
  file_metadata = { lines: [], words: [], bytes: [] }
  total_metadata = { lines: [], words: [], bytes: [] }
  paths = load_option(options)
  contains_paths(paths, file_metadata)

  file_metadata.each do |key, array|
    total_metadata[key] << array.sum
  end
  width = total_metadata.values.max[0].to_s.length
  unless paths.size.equal?(1)
    file_metadata.each_key { |key| file_metadata[key].concat(total_metadata[key]) }
    paths << 'total'
  end
  paths.each_with_index do |path, index|
    show_metadata(file_metadata, index, width, options)
    puts path
  end
end

def load_option(options)
  opts = OptionParser.new
  opts.on('-l', '--lines', 'print the newline counts') { options[:lines] = true }
  opts.on('-w', '--words', 'print the word counts') { options[:words] = true }
  opts.on('-c', '--bytes', 'print the byte counts') { options[:bytes] = true }
  opts.parse!(ARGV)
  ARGV
end

def contains_paths(paths, file_metadata)
  if paths[0].nil?
    add_metadata($stdin.read, file_metadata)
  else
    paths.each { |path| add_metadata(File.read(path), file_metadata) }
  end
end

def add_metadata(content, file_metadata)
  file_metadata[:lines] << content.lines.size
  file_metadata[:words] << content.split(' ').size
  file_metadata[:bytes] << content.bytesize
end

def show_metadata(metadata, index, width, options = {})
  metadata.each_key do |key|
    print "#{metadata[key][index].to_s.rjust(width)} " if !options[key].nil? || options.empty?
  end
end

main
