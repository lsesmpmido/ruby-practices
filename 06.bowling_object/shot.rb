# frozen_string_literal: true

class Shot
  def initialize(score_sheet)
    @scores = score_sheet.split(',')
  end

  def create_shots
    @scores.flat_map do |score|
      score == 'X' ? [10, 0] : score.to_i
    end
  end
end
