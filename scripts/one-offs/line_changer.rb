#!/usr/bin/env ruby

# change line numbers

# go through lines in ppp.01880 and anc.02134 and add +1 to line numbers
# then go through manuscripts / notebooks and remove references there
#   to any lines which were changed in the first two files

require_relative "line_changer/augmenter.rb"
# require_relative "line_changer/corresp_destroyer"

original_ids = Augmenter.new().run
