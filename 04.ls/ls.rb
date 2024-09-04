#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_COUNT = 3
LIST_WIDTH = 18

def main
  options = {}
  opts = OptionParser.new
  opts.on('-a', '--all', 'List all files') { options[:all] = true }
  opts.on('-r', '--reverse', 'List files in reverse order') { options[:reverse] = true }
  opts.on('-l', '--long', 'List long files') { options[:long] = true }
  opts.parse(ARGV)

  flags = options[:all] ? File::FNM_DOTMATCH : 0
  files = Dir.glob('*', flags).sort
  files = files.reverse if options[:reverse]
  if options[:long]
    show_long_file_list(files)
  else
    show_file_list(files, COLUMN_COUNT)
  end
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

def color_file_name(file, permissions)
  if permissions[0] == 'd'
    "\e[1;34m#{file}\e[0m"
  elsif permissions.include?('x')
    "\e[1;32m#{file}\e[0m"
  else
    file
  end
end

def show_long_file_list(files)
  puts "total #{files.sum { |file| File::Stat.new(file).blocks / 2 }}"
  files.each do |file|
    permissions = File.ftype(file) == 'directory' ? 'd' : '-'
    file_status = File::Stat.new(file)
    file_mode = (file_status.mode & 0o777).to_s(8).split('')
    file_mode.each { |digit| permissions += show_permission(digit) }
    print "#{permissions} "
    print "#{file_status.nlink} "
    print "#{Etc.getpwuid(file_status.uid).name} "
    print "#{Etc.getgrgid(file_status.gid).name} "
    print "#{file_status.size.to_s.rjust(4)} "
    print "#{file_status.mtime.strftime('%b')} "
    print "#{file_status.mtime.day.to_s.rjust(2)} "
    print "#{file_status.mtime.strftime('%H:%M')} "
    print "#{color_file_name(file, permissions)}\n"
  end
end

def show_permission(digit)
  {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }[digit]
end

main
