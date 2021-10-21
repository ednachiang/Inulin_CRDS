import os
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes

##### CHANGE THESE PARAMETERS ACCORDINGLY
directoryKaiju = '../kaiju/'
    # Directory of kaiju outputs
    # directoryKaiju/directorySpecificPredictedProtein/taxon
    # CHANGE FUNCTION makeDF ACCORDING TO DIRECTORY

proteins = os.listdir(directoryKaiju)
    # Save all predicted proteins
samples = ['I-P01', 'I-P07', 'I-P11', 'I-S07', 'I-S29', 'I-S34', 'I-W31', 'I-W32', 'I-W33', 'S-P03', 'S-P09', 'S-P12', 'S-S05', 'S-S08', 'S-S32', 'S-W20', 'S-W36', 'S-W37']
sampDict = {0:"I-P01", 1:"I-P07", 2:"I-P11", 3:"I-S07", 4:"I-S29", 5:"I-S34", 6:"I-W31", 7:"I-W32", 8:"I-W33", 9:"S-P03", 10:"S-P09", 11:"S-P12", 12:"S-S05", 13:"S-S08", 14:"S-S32", 15:"S-W20", 16:"S-W36", 17:"S-W37"}
taxon = ["phylum", "class", "order", "family", "genus", "species"]
    # Save all taxa levels




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
        currentSamp = currentSamp[:-17]
        length = len(currentSamp)

        currentSamp = currentSamp[length-6 : length]
        currentSamp = currentSamp.replace("/","")
        currentSamp = currentSamp.replace(".","")

    for taxon1 in taxaDict:
        output.loc[taxon1, currentSamp] = taxaDict[taxon1]
    
    return(output)







##### Define function: XXXXXXXXXXXXXXXX
def summarizeKaiju(input_Path, protein, output_Path, protein_path):

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
for file in os.listdir(directoryKaiju):
    # Iterate for all files in directory
    protein = str(file)
    proteinPath = directoryKaiju + protein + '/'
    print(protein)
    summarizeKaiju(directoryKaiju, protein, directoryKaiju, proteinPath)
