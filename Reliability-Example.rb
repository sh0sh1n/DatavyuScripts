# Reliability script for continuously coded columns

## Params
pri_col_name = 'Example'
rel_col_name = 'Rel_Example'
pri_prefix = 'pri_'
rel_prefix = 'rel_'
merge_col_name = 'rel_merge_example'
codes_to_check = ['somecode', 'othercode']
leeway_ms = 1000
disagreement_col_name = 'rel_example_disagreements'

## Code Body
require 'Datavyu_API.rb'

# Merge primary and reliability columns
mergeCol = createMutuallyExclusive(merge_col_name, pri_col_name, rel_col_name, pri_prefix, rel_prefix)

# Get new code names for primary and reliability codes
priCodeNames = codes_to_check.map{ |x| pri_prefix + x }
relCodeNames = codes_to_check.map{ |x| rel_prefix + x }

# Make new column for disagreements. Note that the code names will be a zipper merge of primary and reliability codes
disagreeCol = createVariable(disagreement_col_name, priCodeNames.zip(relCodeNames).flatten)

# Make table to map each code to its disagreement
disagreements = Hash.new{ |hash, key| hash[key] = 0 }
total = 0
# Iterate over cells and find valid disagreements
for cell in mergeCol.cells
  disagree = false
  for i in 0..(codes_to_check.size-1)
    priValue = cell.get_arg(priCodeNames[i])
    relValue = cell.get_arg(relCodeNames[i])

    # Check for disagreement
    if( (cell.duration > leeway_ms) and (priValue != relValue) )
      # Add duration to map
      disagreements[codes_to_check[i]] += cell.duration

      disagree = true
    end
  end

  # Create disagreement cell if there were any disagreements
  if disagree
    ncell = disagreeCol.make_new_cell
    ncell.onset = cell.onset
    ncell.offset = cell.offset
    for codename in ncell.arglist
      ncell.change_arg(codename, cell.get_arg(codename))
    end
  end

  total += cell.duration
end

# Compute agreement percentages
total = total.to_f
disagreements.each_pair do |key, value|
  puts "Agreement for #{key}: #{100 * (1 - value.to_f/total)}"
end

setVariable(disagreeCol)
