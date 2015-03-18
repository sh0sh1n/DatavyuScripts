require 'Datavyu_API.rb'

begin
	# This enables warnings while running the code
	verbose = 2
	
	# Location of Datavyu files - the directory is in the desktop in a folder called Datavyu files
	dvyudir = File.expand_path('~/Desktop/DatavyuFiles')
	# Location of where to store the ouput - in the dektop in a folder called DataOuput
	outdir = File.expand_path('~/Desktop/DatavyuOutput')

	# This searches for files of interest within the directory - files with an .opf extension
	dvyufiles = Dir.chdir(dvyudir){|dir|Dir.glob("*.opf")}

	# This prints out the datavyu filenames
	puts dvyufiles if verbose > 1

	for file in dvyufiles
		puts "Working on : #{file}"

		# loads database from file $db makes it accessible to other functions and saves it as 
		# a project $pj
		$db,$proj = loadDB(File.join(dvyudir,file))
		
		# Fetch the column/s of interest.  Skip this file if no such column exists.
		col_example1 = getVariable('example1')
		col_example2 = getVariable('example2')
		col_example3 = getVariable('example3')
		
		if col_example3.nil?
			puts "Error: No example3 column found.  Skipping to next file."
			next
		end
		
		# Create the output file with the same name as the file, without the .opf extension.
		# It includes the name 'output' at the end of the file. 'w' gives permission to write.
		outfile = File.new(File.join(outdir,File.basename(file,'.opf')+'_output.txt'),'w')
		
		# Output header
		outfile.puts "example1_code01,example2_code01,example3_ordinal,example3_onset,example3_offset"
				
		# If columns are nested, you can use the following loop.
		for example1cell in col_example1.cells
			for example2cell in col_example2.cells
				for example3cell in col_example3.cells
					if example3cell.onset >= example2cell.onset and example3cell.offset <= example2cell.offset
						if example2cell.onset >= example1cell.onset and example2cell.offset <= example1cell.offset
						   	outfile.write(example1cell.code01 + "\t" + example2cell.code01 + "\t" + example3cell.ordinal.to_s + "\t" + 
							example3cell.onset.to_s + "\t" + example3cell.offset.to_s + "\n")
						end
					end
				end
			end
		end
		
		# Close the output file.
		outfile.close()
	end
	
	puts "Finished."

# Prints specific subsets of error messages to track down the line of script that causes a crash 	
rescue StandardError => e
	puts e.message
	puts e.backtrace
	
# Ensure to close the outfile, no matter what
ensure
	outfile.close() unless outfile.nil? or outfile.closed?
end