# Run a ruby script on a directory of Datavyu files.
# Ask the user for script file path and a folder containing Datavyu files.

# Shohan Hasan
# NYU Infant Action Lab
# 01/20/2015

require 'Datavyu_API.rb'
java_import javax::swing::JFileChooser
java_import javax::swing::filechooser::FileNameExtensionFilter
#java_import java::io::File

begin
	verbose = 1	# level of output to console (higher=more output)
	recurse = false	# set true to search for Datavyu files in subdirectories of selected folder
	# Prompt user for script file.
	rbFilter = FileNameExtensionFilter.new('Ruby script','rb')
	jfc = JFileChooser.new()
	jfc.setAcceptAllFileFilterUsed(false)
	jfc.setFileFilter(rbFilter)
	jfc.setMultiSelectionEnabled(false)
	jfc.setDialogTitle('Select Ruby script file.')

	ret = jfc.showOpenDialog(javax.swing.JPanel.new())

	if ret != JFileChooser::APPROVE_OPTION
		puts "Invalid selection. Aborting."
		return
	end

	script = ''
	scriptFile = jfc.getSelectedFile()
	fn = scriptFile.getName()

	# Make it illegal to open self.
	if fn=='RunBatch.rb' # for some reason __FILE__ doesn't work...this isn't a great solution but it'll have to do until I figure out a more robust implementation
		puts "Illegal to open self. Aborting."
		return
	end

	script = scriptFile.getAbsolutePath()

	puts script if verbose > 1

	# Prompt for user to select directory containing Datavyu files
	jfc.resetChoosableFileFilters()
	jfc.setFileSelectionMode(JFileChooser::DIRECTORIES_ONLY)
	jfc.setDialogTitle('Select folder containing Datavyu files.')

	ret = jfc.showOpenDialog(javax.swing.JPanel.new())

	if ret =! JFileChooser::APPROVE_OPTION
		puts "Invalid selection. Aborting."
		return
	end

	dv_dir = jfc.getSelectedFile().getAbsolutePath()
	puts dv_dir if verbose > 1
	dv_files = []
	filter = (recurse)? File.join('**','*.opf') : '*.opf'
	Dir.chdir(dv_dir){
		|dir|
		dv_files = Dir.glob(filter)
	}

	puts dv_files if verbose > 1

	for file in dv_files
		puts "\n"
		puts "=" * 10
		puts "Working on #{file}" if verbose > 0
		$db,$proj = loadDB(File.join(dv_dir,file))
		load(script)
		saveDB(File.join(dv_dir,file))
	end

rescue StandardError => e
	puts e.message
	puts e.backtrace
end
