#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  files = Dir.glob('*')
  column_count = 3
  show_file_list(files, column_count)
end

def show_file_list(files, column_count)
  row_count = files.size.ceildiv(column_count)
  row_count.times do |row|
    column_count.times do |column|
      print files[row + row_count *column].to_s.ljust(18)
    end
    puts
  end
end

main
