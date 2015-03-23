# Makes an example column with cells.

# Shohan Hasan
# NYU Infant Action Lab
# March 23, 2015
require 'Datavyu_API.rb'
######################### PARAMS ##########################
colName = 'primary'
colArgs = ['code01','code02']
numCells2Make = 1000
cellMinDur = 2000
cellMaxDur = 15000
cellMinGap = 1000
cellMaxGap = 3000
cellCodes = {
	'code01' => ['s','h','o'],
	'code02' => ['s','h','o']
}

######################### MAIN ROUTINE ####################
begin
	myCol = createVariable(colName,colArgs)

	lo = 0	# last offset
	1.upto(numCells2Make){
		ncell = myCol.make_new_cell()
		on = lo + cellMinGap + rand(cellMaxGap)
		off = on + cellMinDur + rand(cellMaxDur)
		ncell.change_arg('onset',on)
		ncell.change_arg('offset',off)
		lo = off

		# Set args
		cellCodes.each_pair{
			|k,v|
			code = v[rand(v.size)]
			ncell.change_arg(k,code)
		}
	}
	# Set column
	setVariable(myCol)
rescue StandardError => e
	puts e.message
	puts e.backtrace
end