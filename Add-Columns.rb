# Add column/arg mappings.  Default behavior for existing columns is to append additional args.
# Shohan Hasan
# NYU Infant Action Lab
require 'Datavyu_API.rb'
########################################
##############  PARAMS  ################
# Column-arg mappings. This is an associative array that pairs the name of the column
# to a list of codes to add to that column.  All codes on the righthand side of each mapping should
# be inside the brackets [] and separated by commas.
myMap = {
	'id' => ['id_number','exp_date','birth_date','sex_mf'],
	'task' => ['condition_xyz'],
	'trial' => ['trial_num','result_yn']
}

# If replace is set to true, any existing columns with the same names will be replaced
# with a blank new column.  YOU CAN NOT UNDO THIS.  When false, only appends argnames
# that are new.
replace = false
verbose = 1

##############  MAIN ROUTINE  ################
begin
	varList = getVariableList()

	columnsAdded = 0
	myMap.each_pair{
		|colname,argnames|
		if not replace and varList.include?(colname)
			puts "#{colname} already exists. Checking for codes to add." if verbose > 0
			col = getVariable(colname)
			newargs = argnames - col.arglist
			newargs.each{ |narg| col.add_arg(narg) }
		else
			puts "Adding column #{colname}" if verbose > 0
			columnsAdded+=1
			col = createVariable(colname,*argnames)
		end
		setVariable(col)
	}
	# Added bandaid fix for the correct number of columns when the script fails.
	puts "Finished.  Added  #{columnsAdded} new column(s)." if verbose > 0
rescue StandardError => e
	puts e.message
	puts e.backtrace
end
