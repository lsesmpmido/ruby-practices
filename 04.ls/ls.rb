#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3
LIST_WIDTH = 18

def main
  options = {}
  opts = OptionParser.new
  opts.on('-a', '--all', 'List all files') { options[:all] = true }
  opts.parse(ARGV)

  files = if options[:all]
            Dir.entries('.')
          else
            Dir.glob('*')
          end
  show_file_list(files.sort, COLUMN_COUNT)
end

def show_file_list(files, column_count)
  row_count = files.size.ceildiv(column_count)
  row_count.times do |row|
    column_count.times do |column|
      print files[row + row_count *column].to_s.ljust(LIST_WIDTH)
    end
    puts
  end
end

main
