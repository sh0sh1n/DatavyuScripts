# Check codes in a spreadsheet.  Written for multi-column support using associative array.
# Shohan Hasan
# NYU Infant Action Lab
require 'Datavyu_API.rb'
########################################
##############  PARAMS  ################
# Column-arg mappings. This is an associative array that pairs the name of the column
# to a list of codes to add to that column.  All codes on the righthand side of each mapping should
# be inside the brackets [] and separated by commas.
myMap = {
	# Columns
	'id' => {
		# Code names 	# Acceptable values
		'sex'		=>	['m','f']
	},
	'task' => {
		'condition'	=>	['x','y','z']
	},
	'trial' => {
		'result_yn'	=>	['y','n']
	}
}

verbose = 1	# zero will be useless until writing out to file is implemented

##############################################
##############  MAIN ROUTINE  ################
begin
	varList = getVariableList()	# Fetch list of columns from spreadsheet

	# Remove columns in myMap that don't exist in the spreadsheet
	# Also prune out mappings that don't have any codes defined.
	myMap.delete_if{
		|colname,codemap|
		if (not varList.include?(colname))
			puts "#{colname} does not exist in spreadsheet. Skipping it." if verbose > 0
			true
		elsif codemap.empty?
			puts "#{colname} contains no codes. Skipping it." if verbose > 0
			true
		else
			false
		end
	}

	# Map column names to column objects from the database
	cols = {}
	myMap.keys.each{
		|x|
		cols[x] = getVariable(x)
	}

	myMap.each_pair{
		|colname,codemap|
		col = cols[colname]

		puts "Checking column: #{colname}" if verbose > 0

		# Get the list of cell objects
		cells = col.cells

		# Get the list of existing codes (column arglist)
		arglist = col.arglist

		# For each cell, check the specified codes against the list of valid codes
		for cell in cells
			codemap.each_pair{
				|codename,legalValues|
				# Check the column's arglist against the codemap.
				# Remove args which don't exist in the arglist from our codemap.
				# NOT IMPLEMENTED. HANDLE USING NIL RETURN VALUES FROM GET_ARG.
				#if not arglist.include?(codename)
				#	puts "WARNING: column #{colname} does not have an argument"
				#end

				v = cell.get_arg(codename)
				if v.nil? or not legalValues.include?(v)
					puts "\tInvalid code for cell\##{cell.ordinal}, code #{codename} : #{v}" if verbose > 0
				end
			}
		end
	}
rescue StandardError => e
	puts e.message
	puts e.backtrace
end
