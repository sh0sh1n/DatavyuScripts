# Insert cells into a secondary column using selection criteria applied to cells of a primary column.
require 'Datavyu_API.rb'
######################### MAIN ROUTINE ####################
begin
	pricol = getVariable('primary')
	pricells = pricol.cells.select{ |c| c.code01 == 's' }		# replace code01 with the actual code you want
	seccol = getVariable('secondary')
	for cell in pricells
		ncell = seccol.make_new_cell
		ncell.change_arg('onset',cell.onset)
		ncell.change_arg('offset',cell.offset)
	end
	setVariable(seccol)
rescue StandardError => e
	puts e.message
	puts e.backtrace
end