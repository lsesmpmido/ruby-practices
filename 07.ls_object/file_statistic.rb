# frozen_string_literal: true

require 'etc'

class FileStatistic
  PERMISSIONS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file_path)
    @file_path = file_path
    @file_stat = File::Stat.new(@file_path)
  end

  def block_size
    @file_stat.blocks / 2
  end

  def mode
    ftype + permission
  end

  def ftype
    File.ftype(@file_path) == 'directory' ? 'd' : '-'
  end

  def permission
    file_mode = (@file_stat.mode & 0o777).to_s(8).split('')
    file_mode.map { |digit| PERMISSIONS[digit] }.join
  end

  def nlink
    @file_stat.nlink
  end

  def uid
    Etc.getpwuid(@file_stat.uid).name
  end

  def gid
    Etc.getgrgid(@file_stat.gid).name
  end

  def byte_size
    @file_stat.size
  end

  def mtime
    @file_stat.mtime
  end

  def name
    @file_path
  end
end
