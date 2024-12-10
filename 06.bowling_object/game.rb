# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(score_sheet)
    marks = score_sheet.split(',')
    @frames = []
    9.times do
      rolls = marks.shift(2)
      if rolls[0] == 'X'
        @frames << Frame.new('X', '0')
        marks.unshift(rolls[1])
      else
        @frames << Frame.new(rolls[0], rolls[1])
      end
    end
    @frames << Frame.new(marks[0], marks[1], marks[2])
  end

  def calc_total_score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.calc_score
      total_score += calc_bonus_score(frame, index) if index < 9
    end
    total_score
  end

  def calc_bonus_score(frame, index)
    bonus_score = 0
    next_frame = @frames[index + 1]
    if frame.strike?
      if next_frame.strike? && index != 8
        after_next_frame = @frames[index + 2]
        bonus_score = next_frame.calc_score(1) + after_next_frame.calc_score(1)
      else
        bonus_score = next_frame.calc_score(2)
      end
    elsif frame.spare?
      bonus_score = next_frame.calc_score(1)
    end
    bonus_score
  end
end
