#!/usr/bin/env ruby
# frozen_string_literal: true

def make_frames(shots)
  frames = []
  shots.each_slice(2) do |s|
    frames << if s[0] == 10
                [s[0]]
              else
                s
              end
  end
  frames
end

def cal_point(frames)
  point = 0
  frames.each_with_index do |frame, index|
    break if index >= 10

    point += if frame[0] == 10
               frame.sum + cal_extra_point(frames[index + 1..], 2)
             elsif frame.sum == 10
               frame.sum + cal_extra_point(frames[index + 1..], 1)
             else
               frame.sum
             end
  end
  point
end

def cal_extra_point(frames, num)
  flatten_frame = frames.flatten
  flatten_frame.shift(num).sum
end

score = ARGV[0]
scores = score.split(',')
shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end
frames = make_frames(shots)
point = cal_point(frames)
puts point
