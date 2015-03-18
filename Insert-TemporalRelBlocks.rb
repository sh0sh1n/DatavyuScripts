# Insert a reliability column based on a percentage of another column's duration.
# This makes sense for columns that are coded continuously.
# The total duration of the source column is calculated by subracting the onset of
# the first cell from the offset of the last cell.

# Shohan Hasan
# NYU Infant Action Lab
# March 17, 2015
require 'Datavyu_API.rb'
######################### PARAMS ##########################
primaryColumn = 'trial'				# Name of column to use for getting total duration
blockColumn = 'trial_rel_block'		# Name of new block column to create
reliabilityColumn = 'trial_rel'		# Name of the new reliability column (no cells)
relFraction = 0.25 					# Fraction of the source column to use as rel_column


######################### MAIN ROUTINE ####################
begin
	src = getVariable(primaryColumn)
	dest = createVariable(blockColumn,'x')
	rel = createVariable(reliabilityColumn,src.arglist)

	srcOnset = src.cells.first.onset
	srcOffset = src.cells.last.offset
	reltime = ((srcOffset-srcOnset) * relFraction).round

	cell = dest.make_new_cell()
	cell.onset = srcOnset + Kernel.rand(srcOffset-reltime) # randomize start of the relblock
	cell.offset = cell.onset+reltime

	setVariable(dest)
	setVariable(rel)

rescue StandardError => e
	puts e.message
	puts e.backtrace
end