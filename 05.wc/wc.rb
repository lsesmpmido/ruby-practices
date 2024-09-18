#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = {}
  file_metadata = { lines: [], words: [], bytes: [], paths: [] }

  paths = load_option(options)
  file_metadata = contains_paths(paths, file_metadata)
  width = file_metadata.values.flatten
                       .select { |num| num.is_a?(Integer) }
                       .map { |num| num.to_s.length }.max
  file_metadata[:paths].each_index do |index|
    show_metadata(file_metadata, index, width, options)
  end
  return if file_metadata[:paths].size <= 1

  total = total_metadata(file_metadata)
  show_metadata(total, 0, width, options)
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
    file_metadata = get_metadata($stdin.read)
  else
    paths.each do |path|
      metadata = get_metadata(File.read(path), path)
      file_metadata = file_metadata.merge(metadata) { |_key, old_value, new_value| old_value + new_value }
    end
    file_metadata
  end
end

def get_metadata(content, path = '')
  metadata = {}
  metadata[:lines] = [content.lines.size]
  metadata[:words] = [content.split(' ').size]
  metadata[:bytes] = [content.bytesize]
  metadata[:paths] = [path]
  metadata
end

def total_metadata(metadata)
  total = metadata.transform_values { [] }
  metadata.each do |key, array|
    if array[0].is_a?(Integer)
      total[key] << array.sum
    else
      total[key] = ['total']
    end
  end
  total
end

def show_metadata(metadata, index, width, options = {})
  metadata.each_key do |key|
    if key.equal?(:paths)
      puts metadata[:paths][index]
    elsif !options[key].nil? || options.empty?
      print "#{metadata[key][index].to_s.rjust(width)} "
    end
  end
end

main
