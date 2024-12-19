# frozen_string_literal: true

require_relative 'file_statistic'

class ListSegment
  COLUMN_COUNT = 3
  LIST_WIDTH = 18

  def initialize(options)
    @options = options
    flags = @options[:all] ? File::FNM_DOTMATCH : 0
    file_paths = Dir.glob('*', flags).sort
    file_paths = file_paths.reverse if @options[:reverse]
    @file_statistics = file_paths.map { |file_path| FileStatistic.new(file_path) }
  end

  def execute
    if @options[:long]
      display_long
    else
      display_short
    end
  end

  private

  def display_long
    puts "合計 #{@file_statistics.sum(&:block_size)}"
    @file_statistics.each do |file_statistic|
      attribute = [
        file_statistic.mode,
        file_statistic.nlink,
        file_statistic.uid,
        file_statistic.gid,
        file_statistic.byte_size.to_s.rjust(4),
        file_statistic.mtime.strftime('%-m月').rjust(3),
        file_statistic.mtime.day.to_s.rjust(2),
        file_statistic.mtime.strftime('%H:%M'),
        file_statistic.name
      ]
      puts attribute.join(' ')
    end
  end

  def display_short
    row_count = @file_statistics.size.ceildiv(COLUMN_COUNT)
    row_count.times do |row|
      COLUMN_COUNT.times do |column|
        file_statistic = @file_statistics[row + row_count * column]
        print file_statistic.name.ljust(LIST_WIDTH) if file_statistic
      end
      puts
    end
  end
end
