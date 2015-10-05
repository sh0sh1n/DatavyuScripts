# Purpose

# Author
# Affiliation and/or e-mail
# Date

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
require 'Datavyu_API.rb'
begin
	puts "Starting script..." if verbose > 0	# Print a simple start message (if verbose greater than 0)



# You can ignore this block.
rescue StandardError => e
	puts e.message
	puts e.backtrace
end
