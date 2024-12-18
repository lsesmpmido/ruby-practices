# frozen_string_literal: true

require 'etc'

class FileMetadata
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
    @file = file_path
    @file_status = File::Stat.new(@file)
  end

  def block_size
    @file_status.blocks / 2
  end

  def mode
    ftype + permission
  end

  def ftype
    File.ftype(@file) == 'directory' ? 'd' : '-'
  end

  def permission
    file_mode = (@file_status.mode & 0o777).to_s(8).split('')
    file_mode.map { |digit| PERMISSIONS[digit] }.join
  end

  def nlink
    @file_status.nlink
  end

  def uid
    Etc.getpwuid(@file_status.uid).name
  end

  def gid
    Etc.getgrgid(@file_status.gid).name
  end

  def byte_size
    @file_status.size
  end

  def mtime
    @file_status.mtime
  end

  def name
    @file
  end
end
