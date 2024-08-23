#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  files = Dir.glob('*')
  column_number = 3
  row_number = (files.size / column_number.to_f).ceil
  show_file_list(files, column_number, row_number)
end

def show_file_list(files, column_number, row_number)
  row_number.times do |r|
    column_number.times do |c|
      print files[r + row_number * c].to_s.ljust(18)
    end
    puts
  end
end

main
