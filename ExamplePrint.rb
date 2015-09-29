# Example print script.  Assumes columns are organized in a hierarchical fashion 
# and listed in order of decreasing inclusivity.

# March 18, 2015
require 'Datavyu_API.rb'
########################################
##############  PARAMS  ################
verbose = 1

begin
	outfile = File.new('/Users/shohanhasan/Desktop/printedData.csv','w+')

	colID = getVariable('id')
	colCondition = getVariable('condition')
	colTrial = getVariable('trial')

	for idcell in colID.cells
		for ccell in colCondition.cells.select{ |x| idcell.contains(x) }
			for tcell in colTrial.cells.select{ |x| ccell.contains(x) }
				begin
					row = idcell.argvals + [ccell.ordinal ccell.onset ccell.offset] ccell.argvals +
							[tcell.ordinal tcell.onset tcell.offset] + tcell.argvals
					outfile.puts(row.join(','))
				rescue IOException => e
					retry
				end
			end
		end
	end
rescue StandardError=> e
	puts e.message
	puts e.backtrace
end

