#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

COLUMN_COUNT = 3
LIST_WIDTH = 18

def main
  options = {}
  opts = OptionParser.new
  opts.on('-a', '--all', 'List all files') { options[:all] = true }
  opts.on('-r', '--reverse', 'List files in reverse order') { options[:reverse] = true }
  opts.parse(ARGV)

  flags = options[:all] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags).sort
  files = files.reverse if options[:reverse]
  show_file_list(files, COLUMN_COUNT)
end

def show_file_list(files, column_count)
  row_count = files.size.ceildiv(column_count)
  row_count.times do |row|
    column_count.times do |column|
      print files[row + row_count * column].to_s.ljust(LIST_WIDTH)
    end
    puts
  end
end

main
