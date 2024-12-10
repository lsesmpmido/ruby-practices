# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark).convert_score
    @second_shot = Shot.new(second_mark).convert_score
    @third_shot = Shot.new(third_mark).convert_score
  end

  def calc_score(number_of_shots = 3)
    case number_of_shots
    when 1
      @first_shot
    when 2
      @first_shot + @second_shot
    when 3
      @first_shot + @second_shot + @third_shot
    end
  end

  def strike?
    calc_score(1) == 10
  end

  def spare?
    calc_score(2) == 10
  end
end
