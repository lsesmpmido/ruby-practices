#!/usr/bin/env ruby
require 'optparse'
require 'date'

# オプションのデフォルト値を設定
today = Date.today
options = {
  month: today.month,
  year: today.year
}

# オプションの値をコマンドラインから取得
opt = OptionParser.new
opt.on('-m', '--month MONTH') { |m| options[:month] = m.to_i }
opt.on('-y', '--year YEAR') { |y| options[:year] = y.to_i }
opt.parse!(ARGV)

# 日付を取得
first_date = Date.new(options[:year], options[:month], 1)
last_date = Date.new(options[:year], options[:month], -1)
days = [*1..last_date.day]

# カレンダーを出力
puts "      #{options[:month]}月 #{options[:year]}"
puts '日 月 火 水 木 金 土'
first_date.wday.times { printf '   ' }
days.each do |day|
  printf '%2d ', day
  printf "\n" if ((day + first_date.wday) % 7).zero?
end
printf "\n"
