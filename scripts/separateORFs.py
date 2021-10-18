import os
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes

##### CHANGE THESE PARAMETERS ACCORDINGLY
directoryFasta = '../eCAMI/exo_fasta/'
    # Directory of endo-inulinase fasta files
newDir = '../eCAMI/exo_fasta_sep/'

### Run Code ###
os.mkdir(newDir)

for sampleFasta in os.listdir(directoryFasta):
        # Iterate for all files in the directory

        inputPath = directoryFasta + sampleFasta
        sample = str(sampleFasta[:5])
        print(sample + ' start')

        faaInput = open(inputPath, mode = 'r')
        counter = 0

        for line in faaInput.readlines():

            if '>' in line:
                counter += 1
                sepFastaPath = newDir + sample + "_" + str(counter) + ".fasta"
                sepFasta = open(sepFastaPath, mode = 'w')
                sepFasta.write(line)
            else:
                sepFasta.write(line)