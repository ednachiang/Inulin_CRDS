import os
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes

##### CHANGE THESE PARAMETERS ACCORDINGLY
directoryEndo = '../eCAMI/exo_fasta/'
    # Directory of endo-inulinase fasta files
outputName = 'exo_ORF_length.csv'

df = pd.DataFrame(columns = [])


##### DEFINE FUNCTION
def calculateGeneLength(input):
    # Input = fasta file

    faaInput = open(input, mode = 'r')

    sampDict = {}

    for line in faaInput.readlines():

        if '>' in line:
            lineSplit = line.split('#')
            ORFname = lineSplit[0]
            start = int(lineSplit[1])
            end = int(lineSplit[2])
            length = end - start + 1
            sampDict[ORFname] = length
    
    return(sampDict)



### Run Code ###

for sampleFasta in os.listdir(directoryEndo):
    # Iterate for all files in the directory

    inputPath = directoryEndo + sampleFasta
    sample = str(sampleFasta[:5])
    print(sample + ' start')
    print(inputPath)
    
    sampleDict = calculateGeneLength(inputPath)
    sampleDF = pd.DataFrame.from_dict(sampleDict, orient = 'index')
    sampleDF['Sample'] = sample

    df = df.append(sampleDF)


outputPath = directoryEndo + outputName
df.columns = ['Length', 'Sample']
df.to_csv(outputPath)


print('Completed!')



