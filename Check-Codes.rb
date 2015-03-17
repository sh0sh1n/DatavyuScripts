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
		'idNumber'	=>	[],
		'expDate'	=>	[],
		'birthDate'	=>	[],
		'sex'		=>	[]
		},
	'task' => {
		'condition'	=>	[]
	}
	'trial' => {
		'result_yn'	=>	[]
	}
}

verbose = 1

########################################
##############  PARAMS  ################
begin
	varList = getVariableList()	# Fetch list of columns from spreadsheet

	# Remove columns in myMap that don't exist in the spreadsheet
	# Also prune out mappings that don't have any codes defined.
	myMap.delete_if{
		|colname,codemap|
		if (not varList.include?(colname))
			puts "#{colname} does not exist in spreadsheet. Skipping it." if verbose > 0
			return true
		elsif codemap.empty?)
			puts "#{colname} contains no codes. Skipping it." if verbose > 0
			return true
		else
			return false
		end
	}

	# Map the column names to RVarible objects.
	cols = myMap.keys.map{ |x| getVariable(x) }

	return

	
	columnsAdded = 0
	myMap.each_pair{
		|colname,argnames|
		puts "Adding column #{colname}" if verbose > 0
		if not replace and varList.include?(colname)
			col = getVariable(colname)
			newargs = argnames - col.arglist
			newargs.each{ |narg| col.add_arg(narg) }
		else
			columnsAdded+=1
			col = createVariable(colname,argnames)
		end
		setVariable(colname,col)
	}
	puts "Finished.  Added #{columnsAdded} new column(s)."
rescue StandardError => e
	puts e.message
	puts e.backtrace
end
