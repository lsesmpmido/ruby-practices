#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

score_sheet = ARGV[0]
game = Game.new(score_sheet)
puts game.calc_point
