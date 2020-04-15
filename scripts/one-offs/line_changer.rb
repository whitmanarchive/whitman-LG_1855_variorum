#!/usr/bin/env ruby

require_relative "line_changer/helpers.rb"
require_relative "line_changer/augmenter.rb"
require_relative "line_changer/remover.rb"


# go through lines in ppp.01880 and anc.02134 and add +1 to line numbers

# Augmenter.new().run



# then go through manuscripts / notebooks and remove references there
#   to any lines which were changed in the first two files

Remover.new().run
