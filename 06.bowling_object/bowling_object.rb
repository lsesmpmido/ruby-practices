#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'
require_relative 'point'

score_sheet = ARGV[0]
shots = Shot.new(score_sheet).create_shots
frames = Frame.new(shots).create_frames
point = Point.new(frames).calc_point
puts point
