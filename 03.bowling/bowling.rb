#!/usr/bin/env ruby
# frozen_string_literal: true

def main
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
  frames = create_frames(shots)
  point = calc_point(frames)
  puts point
end

def create_frames(shots)
  frames = shots.each_slice(2).map do |s|
    s[0] == 10 ? [s[0]] : s
  end
end

def calc_point(frames)
  point = 0
  frames.each_with_index do |frame, index|
    break if index >= 10

    point += if frame[0] == 10
               frame.sum + calc_extra_point(frames[index + 1..], 2)
             elsif frame.sum == 10
               frame.sum + calc_extra_point(frames[index + 1..], 1)
             else
               frame.sum + calc_extra_point(frames[index + 1..], 0)
             end
  end
  point
end

def calc_extra_point(frames, additional_range)
  frames.flatten.first(additional_range).sum
end

main
