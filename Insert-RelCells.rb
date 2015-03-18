# Insert reliability cells based on a percentage of primary coder's cells.

# Shohan Hasan
# NYU Infant Action Lab
# March 17, 2015
require 'Datavyu_API.rb'
######################### PARAMS ##########################
primaryColumn = 'trial'				# Name of column to use for getting total duration
reliabilityColumn = 'trial_rel'		# Name of the new reliability column (no cells)
relFraction = 0.25 					# Fraction of the source column to use as rel_column


######################### MAIN ROUTINE ####################
begin
	pri = getVariable(primaryColumn)
	rel = createVariable(reliabilityColumn,pri.arglist)

	numcells = ((pri.cells.last.ordinal.to_i)*relFraction).round
	relcells = pri.cells.shuffle.take(numcells)

	for cell in relcells
		c = rel.make_new_cell
		c.onset = cell.onset
		c.offset = cell.offset
	end

	setVariable(rel)
rescue StandardError => e
	puts e.message
	puts e.backtrace
end