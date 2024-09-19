#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  paths, options = load_argument
  metadata_list = paths.empty? ? [get_metadata($stdin.read)] : get_metadata_from_paths(paths)
  filtered_metadata_list = metadata_list.map { |metadata| metadata.select { |_, value| value.is_a?(Integer) } }
  max_value = filtered_metadata_list.flat_map { |hash| hash.values.flatten }.max
  padding_width = max_value.to_s.length
  show_metadata(metadata_list, padding_width, options)
  return if metadata_list.size <= 1

  total = total_metadata(metadata_list)
  show_metadata(total, padding_width, options)
end

def load_argument
  options = {}
  opts = OptionParser.new
  opts.on('-l', '--lines', 'print the newline counts') { options[:line_count] = true }
  opts.on('-w', '--words', 'print the word counts') { options[:word_count] = true }
  opts.on('-c', '--bytes', 'print the byte counts') { options[:byte_count] = true }
  opts.parse!(ARGV)
  [ARGV, options]
end

def get_metadata_from_paths(paths)
  metadata_list = []
  paths.each do |path|
    content = File.read(path)
    metadata_list << get_metadata(content, path)
  end
  metadata_list
end

def get_metadata(content, path = '')
  metadata = {}
  metadata[:line_count] = content.lines.size
  metadata[:word_count] = content.split(' ').size
  metadata[:byte_count] = content.bytesize
  metadata[:path] = path
  metadata
end

def total_metadata(metadata_list)
  total = { line_count: 0, word_count: 0, byte_count: 0, path: '' }
  metadata_list.each_index do |index|
    metadata_list[index].each do |key, value|
      total[key] += value if value.is_a?(Integer)
    end
    total[:path] = 'total'
  end
  [total]
end

def show_metadata(metadata_list, padding_width, options)
  metadata_list.each_index do |index|
    metadata_list[index].each_key do |key|
      if key.equal?(:path)
        puts metadata_list[index][:path]
      elsif !options[key].nil? || options.empty?
        print "#{metadata_list[index][key].to_s.rjust(padding_width)} "
      end
    end
  end
end

main
