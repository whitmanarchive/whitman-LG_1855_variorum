#!/usr/bin/env ruby

require_relative "line_changer/helpers.rb"
require_relative "line_changer/augmenter.rb"
require_relative "line_changer/remover.rb"


# go through lines in ppp.01880 and anc.02134 and add +1 to line numbers
# Augmenter.new().run

# then go through manuscripts / notebooks and find places to remove
# references there, but do NOT actually remove them

Remover.new().run


## DOCUMENTATION

# Run this file:
#  ruby scripts/one-offs/line_changer.rb
#
# The augmenter should never need to be run again, but uncomment if you do need to
# The remover is no longer removing lines from files, but instead reporting
#   on the location of corresps that should be removed.
# Presumably this script is no longer needed at all, but keeping for reference
#   about what was changed and when
