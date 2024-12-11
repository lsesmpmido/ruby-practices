# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark = nil)
    @frame = [first_mark, second_mark, third_mark].compact.map { |mark| Shot.new(mark) }
  end

  def calc_score(number_of_shots = @frame.size)
    @frame.take(number_of_shots).sum(&:score)
  end

  def strike?
    calc_score(1) == 10
  end

  def spare?
    calc_score(2) == 10 && !strike?
  end
end
