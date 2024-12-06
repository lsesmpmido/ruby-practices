# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(score_sheet)
    shot = Shot.new(score_sheet)
    frame = Frame.new(shot.create_shots)
    @frames = frame.create_frames
  end

  def calc_point
    @frames.take(10).each_with_index.sum do |frame, index|
      bonus_cnt = if frame[0] == 10
                    2
                  elsif frame.sum == 10
                    1
                  else
                    0
                  end
      bonus = @frames[index + 1..].flatten.take(bonus_cnt).sum
      frame.sum + bonus
    end
  end
end
