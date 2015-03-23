# Insert cells into a secondary column using selection criteria applied to cells of a primary column.

# Shohan Hasan
# NYU Infant Action Lab
# March 23, 2015
require 'Datavyu_API.rb'
######################### PARAMS ##########################
primaryColumn = 'primary'			# Name of primary column
secondaryColumn = 'secondary'		# Name of secondary column
selectCriteria = { 					# Codes and their valid values to use as selection criteria
	'code01'	=>	['s'],
	'code02'	=>	['h','o']
}
selectCriteraAll = false				# Sets the condition for selection.  Set to false to select if any criterion matches.  Set to true to select iff all critera match.
setOnset = true						# Set true to copy over onsets
setOffset = true					# Set true to copy over offsets
clobber = false						# Set true to overwriter secondaryColumn if it already exists
secondaryCodes = ['s','h','o']		# Codes to initialize in secondary column if creating new column
verbose = 1 						# Verbosity, higher = more verbose output

######################### MAIN ROUTINE ####################
begin
	# Fetch primary and secondary columns.
	puts "Fetching column #{primaryColumn}" if verbose > 0
	colPri = getVariable(primaryColumn)
	raise "ColumnNotFound: #{primaryColumn}" if colPri.nil?

	if clobber
		puts "Creating column #{secondaryColumn}" if verbose > 0
		colSec = createVariable(secondaryColumn,secondaryCodes)
	else
		puts "Fetching column #{secondaryColumn}" if verbose > 0
		colSec = getVariable(secondaryColumn)
		raise "ColumnNotFound: #{secondaryColumn}" if colSec.nil?
	end

	# Select cells based on selectCriteria
	candCells = colPri.cells.select{
		|c|
		# Warning: logic ahead
		valid = selectCriteraAll
		selectCriteria.each_pair{
			|code,values|
			if selectCriteraAll
				valid &= values.include?(c.get_arg(code))
			else
				valid |= values.include?(c.get_arg(code))
			end
		}
		valid
	}

	for cell in candCells
		ncell = colSec.make_new_cell()
		ncell.change_arg('onset',cell.onset) if setOnset
		ncell.change_arg('offset',cell.offset) if setOffset
	end

	puts "Saving column #{secondaryColumn} to database" if verbose > 0
	setVariable(colSec)
rescue StandardError => e
	puts e.message
	puts e.backtrace
end