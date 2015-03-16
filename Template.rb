# Purpose

# Author
# Affiliation and/or e-mail
# Date

require 'Datavyu_API.rb'

#####################################################
##################### PARAMETERS ####################
#####################################################
# Control verbosity debugging and informative messages.
# I generally set this to 1 by default and set it higher when I want to debug.
# This doesn't actually invoke automated messages, you have to print the messages
# yourself in the rest of the script.
verbose = 1

#####################################################
##################### Main routine ##################
#####################################################
begin
	puts "Starting script..." if verbose > 0	# Print a simple start message (if verbose greater than 0)



# You can ignore this block.  If find that this does a better
# job of tracking down the line in the script that caused a crash.
rescue StandardError => e
	puts e.message
	puts e.backtrace
end
