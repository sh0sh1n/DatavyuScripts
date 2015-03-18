# Just a template for the checkReliability function in the API.

# Shohan Hasan
# NYU Infant Action Lab
# March 17, 2015
require 'Datavyu_API.rb'
######################### PARAMS #####################
primaryColumn = 		'trial'			# name of primary column
reliabilityColumn = 	'trial_rel'		# name of reliability column

cellIdentifier = 		'trialnum'	# code in primary and reliability cells that identify the same coded part of the video
timeTolerance =			100				# millisecond to use as buffer for onset/offset disagreements

verbose = 1
######################### MAIN #######################
begin
	checkReliability(primaryColumn,reliabilityColumn,cellIdentifier,timeTolerance)
rescue StandardError => e
	puts e.message
	puts e.backtrace
end