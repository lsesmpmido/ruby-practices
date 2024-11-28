# frozen_string_literal: true

class Frame
  def initialize(shots)
    @shots = shots
  end

  def create_frames
    @shots.each_slice(2).map do |frame|
      frame[0] == 10 ? [10] : frame
    end
  end
end
