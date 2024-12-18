#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'list_segment'

options = { all: false, reverse: false, long: false }
opts = OptionParser.new
opts.on('-a', '--all', 'List all files') { options[:all] = true }
opts.on('-r', '--reverse', 'List files in reverse order') { options[:reverse] = true }
opts.on('-l', '--long', 'List long files') { options[:long] = true }
opts.parse(ARGV)

ls = ListSegment.new(options)
ls.display
