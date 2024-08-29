#!/usr/bin/env ruby
# frozen_string_literal: true

COLUMN_COUNT = 3
LIST_WIDTH = 18

def main
  files = Dir.glob('*')
  show_file_list(files, COLUMN_COUNT)
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
