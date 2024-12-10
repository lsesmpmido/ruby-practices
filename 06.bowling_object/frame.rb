# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark = nil)
    @frame = [Shot.new(first_mark), Shot.new(second_mark), Shot.new(third_mark)].compact
  end

  def calc_score(number_of_shots = @frame.size)
    @frame.take(number_of_shots).sum(&:convert_score)
  end

  def strike?
    calc_score(1) == 10
  end

  def spare?
    calc_score(2) == 10 && !strike?
  end
end
