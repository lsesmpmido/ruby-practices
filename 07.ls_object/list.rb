# frozen_string_literal: true

require_relative 'option'
require_relative 'file'

class List
  COLUMN_COUNT = 3
  LIST_WIDTH = 18

  def initialize(options)
    @options = options
    @files = []
    flags = @options[:all] ? File::FNM_DOTMATCH : 0
    file_names = Dir.glob('*', flags).sort
    file_names = file_names.reverse if @options[:reverse]
    file_names.each do |file_name|
      @files << File.new(file_name, @options)
    end
  end

  def display
    if @options[:long]
      puts "合計 #{@files.sum(&:block_size)}"
      @files.each do |file|
        puts file.metadata
      end
    else
      row_count = @files.size.ceildiv(COLUMN_COUNT)
      row_count.times do |row|
        COLUMN_COUNT.times do |column|
          file = @files[row + row_count * column]
          print file.metadata.to_s.ljust(LIST_WIDTH) if file
        end
        puts
      end
    end
  end
end
