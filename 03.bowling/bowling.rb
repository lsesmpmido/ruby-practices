#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  score = ARGV[0]
  scores = score.split(',')
  shots = scores.flat_map do |s|
    s == 'X' ? [10, 0] : s.to_i
  end
  frames = create_frames(shots)
  puts calc_point(frames)
end

def create_frames(shots)
  shots.each_slice(2).map do |s|
    s[0] == 10 ? [s[0]] : s
  end
end

def calc_point(frames)
  frames.take(10).each_with_index.sum do |frame, index|
    bonus_cnt = if frame[0] == 10
                         2
                       elsif frame.sum == 10
                         1
                       else
                         0
                       end
    frame.sum + calc_additional_point(frames[index + 1..], bonus_cnt)
  end
end

def calc_additional_point(frames, bonus_cnt)
  frames.flatten.take(bonus_cnt).sum
end

main
