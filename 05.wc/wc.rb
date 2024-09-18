#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  paths, options = load_argument
  metadata_list = paths.empty? ? get_metadata : contains_paths(paths)
  width = metadata_list.values.flatten
                       .select { |num| num.is_a?(Integer) }
                       .map { |num| num.to_s.length }.max
  metadata_list[:paths].each_index do |index|
    show_metadata(metadata_list, index, width, options)
  end
  return if metadata_list[:paths].size <= 1

  total = total_metadata(metadata_list)
  show_metadata(total, 0, width, options)
end

def load_argument
  options = {}
  opts = OptionParser.new
  opts.on('-l', '--lines', 'print the newline counts') { options[:lines] = true }
  opts.on('-w', '--words', 'print the word counts') { options[:words] = true }
  opts.on('-c', '--bytes', 'print the byte counts') { options[:bytes] = true }
  opts.parse!(ARGV)
  [ARGV, options]
end

def contains_paths(paths)
  metadata_list = { lines: [], words: [], bytes: [], paths: [] }
  paths.each do |path|
    metadata = get_metadata(path)
    metadata_list = metadata_list.merge(metadata) { |_key, old_value, new_value| old_value + new_value }
  end
  metadata_list
end

def get_metadata(path = '')
  content = path.empty? ? $stdin.read : File.read(path)
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

def show_metadata(metadata, index, width, options)
  metadata.each_key do |key|
    if key.equal?(:paths)
      puts metadata[:paths][index]
    elsif !options[key].nil? || options.empty?
      print "#{metadata[key][index].to_s.rjust(width)} "
    end
  end
end

main
