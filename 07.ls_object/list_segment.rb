# frozen_string_literal: true

require_relative 'file_attribute'

class ListSegment
  COLUMN_COUNT = 3
  LIST_WIDTH = 18

  def initialize(options)
    @options = options
    flags = @options[:all] ? File::FNM_DOTMATCH : 0
    file_paths = Dir.glob('*', flags).sort
    file_paths = file_paths.reverse if @options[:reverse]
    @files = file_paths.map { |file_path| FileAttribute.new(file_path) }
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
    puts "合計 #{@files.sum(&:block_size)}"
    @files.each do |file|
      attribute = [
        file.mode,
        file.nlink,
        file.uid,
        file.gid,
        file.byte_size.to_s.rjust(4),
        file.mtime.strftime('%-m月').rjust(3),
        file.mtime.day.to_s.rjust(2),
        file.mtime.strftime('%H:%M'),
        file.name
      ]
      puts attribute.join(' ')
    end
  end

  def display_short
    row_count = @files.size.ceildiv(COLUMN_COUNT)
    row_count.times do |row|
      COLUMN_COUNT.times do |column|
        file = @files[row + row_count * column]
        print file.name.ljust(LIST_WIDTH) if file
      end
      puts
    end
  end
end
