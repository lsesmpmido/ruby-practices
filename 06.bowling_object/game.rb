# frozen_string_literal: true

class Game
  def initialize(frames)
    @frames = frames
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
