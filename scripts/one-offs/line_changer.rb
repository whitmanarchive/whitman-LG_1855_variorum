#!/usr/bin/env ruby

require_relative "line_changer/helpers.rb"
require_relative "line_changer/augmenter.rb"
require_relative "line_changer/remover.rb"


# go through lines in ppp.01880 and anc.02134 and add +1 to line numbers

# Augmenter.new().run



# then go through manuscripts / notebooks and find places to remove
# references there, but do NOT actually remove them

Remover.new().run
