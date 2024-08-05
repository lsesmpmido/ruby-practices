#!/usr/bin/env ruby
require 'optparse'
require 'date'

today = Date.today
options = {
  month: today.month,
  year: today.year
}

opt = OptionParser.new
opt.on('-m', '--month MONTH') { |m| options[:month] = m.to_i }
opt.on('-y', '--year YEAR') { |y| options[:year] = y.to_i }
opt.parse!(ARGV)

first_date = Date.new(options[:year], options[:month], 1)
last_date = Date.new(options[:year], options[:month], -1)

puts "      #{options[:month]}月 #{options[:year]}"
puts '日 月 火 水 木 金 土'
print '   ' * first_date.wday
(first_date..last_date).each do |date|
  print date.day.to_s.rjust(2) + " "
  puts if ((date.day + first_date.wday) % 7).zero?
end
puts
