import os
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes
import csv

##### CHANGE THESE PARAMETERS ACCORDINGLY
directoryeCAMI = '../eCAMI/sig_cazymes/'
    # Directory of eCAMI outputs
    # directoryeCAMI/directorySpecificPredictedProtein/
    # CHANGE FUNCTION makeDF ACCORDING TO DIRECTORY

proteins = os.listdir(directoryeCAMI)
    # Save all predicted proteins

output = {}

##### Define function #####
def makeDF(inputFile, outputFile):

    input = open(inputFile, mode = "r")
    output = outputFile

    for line1 in input.readlines()[1:]:





for line1 in eCAMI:
	if '>' in line1:
        line_split = line1.split('	')
        print(line_split)
        EC = line1.split('	')[1]
        print(EC)




##### Define function: XXXXXXXXXXXXXXXX
def makeDF(taxaList, dataFrame, inputFile, taxaDict):
    
    input = open(inputFile, mode = "r")
    output = dataFrame
    #print(dataFrame)

    for line1 in input.readlines()[1:]:
        #print(line1)
        line1Split = line1.split('	')
        taxonName = line1Split[4]
        taxonName = taxonName[:-1]
        taxaDict[taxonName] = (line1Split[1])
        currentSamp = line1Split[0]

        ## FOR INULINASES ##
        #currentSamp = currentSamp[:-17]

        ## FOR ALL SHORT READS ##  
        #currentSamp = currentSamp[:-12]

        ## FOR SIG CAZYMES ##
        currentSamp = currentSamp[:-18]
        length = len(currentSamp)

        currentSamp = currentSamp[length-6 : length]
        currentSamp = currentSamp.replace("/","")
        currentSamp = currentSamp.replace(".","")

    for taxon1 in taxaDict:
        output.loc[taxon1, currentSamp] = taxaDict[taxon1]
    
    return(output)







##### Define function: XXXXXXXXXXXXXXXX
def summarize_eCAMI(input_Path, protein, output_Path, protein_path):

    for taxa in taxon:
        # Working taxon-by-taxon

        # Save output path
        outputPath = protein_path + protein + '.' + taxa + '.csv'

        # Empty list of taxa
        taxaList = []
        
        # Save paths for all kaiju files
        kaijuFiles = []
        for file1 in os.listdir(protein_path+taxa+'/'):
            #print(file1)
            kaijuPath = protein_path + taxa + '/' + file1
            kaijuFiles.append(kaijuPath)

        for file2 in kaijuFiles:
            kaijuInput = pd.read_table(file2)
            taxaCol = kaijuInput["taxon_name"].values.tolist()
                # Same taxon name column and convert that dataframe column into a list

            for taxa1 in taxaCol:
                if taxa1 in taxaList:
                    continue
                else:
                    taxaList.append(taxa1)
        
        #print(taxaList)
            
        df1 = pd.DataFrame(index = taxaList, columns = samples)


        for file3 in kaijuFiles:
            taxaDict = {}
            df2 = makeDF(taxaList, df1, file3, taxaDict)
        
        df2 = df2.fillna(0)
        df2.to_csv(outputPath)






##### Run Code #####
for file in os.listdir(directoryeCAMI):
    # Iterate for all files in directory
    protein = str(file)
    proteinPath = directoryeCAMI + protein + '/'
    print(protein)
    print(proteinPath)
    summarize_eCAMI(directoryeCAMI, protein, directoryeCAMI, proteinPath)