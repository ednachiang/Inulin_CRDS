import os
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes

##### CHANGE THESE PARAMETERS ACCORDINGLY
directoryKaiju = 'test/kaiju/'
    # Directory of kaiju output
directoryOutput = 'test/output/'
    # Directory of output


##### Defin function
def kaiju_to_OTU_table(inputPath, outputPath):

    # Save paths for all kaiju.tsv files
    kaiju_files = []
    for file1 in os.listdir(inputPath):
        kaijuPath = inputPath + file1
        kaiju_files.append(kaijuPath)
    
    # Create number list for 'for' loops to iterate through all kaiju files
    fileNumber = range(0, len(kaiju_files))

    for file2 in fileNumber:
        # Save sample ID
        sample = str(kaiju_files[file2][-7:-4])
        print(sample)

        dictPhylum = { }
        dictClass = { }
        dictOrder = { }
        dictFamily = { }
        dictGenus = { }
        dictSpecies = { }

        # Open input file
        kaijuInput = open(kaiju_files[file2])
        print(kaiju_files[file2])
        counter = 0
        counter_phylum = 0
        counter_class = 0
        counter_order = 0
        counter_family = 0
        counter_genus = 0
        counter_species = 0

        for line1 in kaijuInput.readlines():
        # Go through kaiju file line-by-line

            col = line1.split('\t')
                # Split row by tabs
            
            #print(col)
            #print(col.count('"NA"'))

            empty = col.count('"NA"')

            # If the 3rd column is NA
            if col[2] == "NA":
                if counter < 3:
                    if '"Viruses"' in col:
                        dictPhylum["Viruses"] = col[0]
                        counter += 1
                    elif '"cannot be assigned to a (non-viral) phylum"' in col:
                        dictPhylum["cannot be assigned to a (non-viral) phylum"] = col[0]
                        counter += 1
                    elif '"unclassified"' in col:
                        dictPhylum["Unclassified"] = col[0]
                        counter += 1
                else: continue

            # For phyla-level
            if empty == 4:
            #if empty == 5:
                #print(col)
                #if col[2] == "NA":
                #    print(col)
                #    dictClass[col[3]] = { }
                #    dictClass[(col[3] + "_count")] = col[0]
                #else:
                counter_phylum += 1
                newDict = 'Phylum_Dict' + str(counter_phylum) = { }
                print(newDict)
                newDict = { }
                dictPhylum[col[2]] = { newDict }
                dictPhylum[(col[2] + '_count')] = col[0]

            # For class-level
            elif empty == 3:
                if col[3] in dictPhylum:
                    print(col)
                    dictPhylum[col[2]] = { col[3] : { } }
                    print(dictPhylum[col[2]])
                    #dictPhylum(col[3]) = { (col[4] + "_count") : col[0] }
                else:
                    dictPhylum[col[2]] = { }
                    dictPhylum[(col[2] + '_count')] = col[0]
            
            # For order-level
            #elif empty == 2:
               # if col[4] in dict
        
        print(dictPhylum)


                

                



    


    
##### Run code #####
kaiju_to_OTU_table(directoryKaiju, directoryOutput)