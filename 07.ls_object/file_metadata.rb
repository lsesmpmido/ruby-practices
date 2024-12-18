# frozen_string_literal: true

require 'etc'

class FileMetadata
  def initialize(file_path, options)
    @file = file_path
    @options = options
  end

  def permission(digit)
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

  def metadata
    metadata = ''
    file_status = File::Stat.new(@file)
    file_mode = (file_status.mode & 0o777).to_s(8).split('')
    permissions = file_mode.map { |digit| permission(digit) }.join
    permissions.prepend(File.ftype(@file) == 'directory' ? 'd' : '-')
    if @options[:long]
      metadata += "#{permissions} "
      metadata += "#{file_status.nlink} "
      metadata += "#{Etc.getpwuid(file_status.uid).name} "
      metadata += "#{Etc.getgrgid(file_status.gid).name} "
      metadata += "#{file_status.size.to_s.rjust(4)} "
      metadata += "#{file_status.mtime.strftime('%-m月').rjust(3)} "
      metadata += "#{file_status.mtime.day.to_s.rjust(2)} "
      metadata += "#{file_status.mtime.strftime('%H:%M')} "
    end
    metadata + @file.to_s
  end

  def block_size
    File::Stat.new(@file).blocks / 2
  end
end
