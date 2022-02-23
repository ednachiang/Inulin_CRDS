import os
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes



directory_eCAMI = '../eCAMI/sig_cazymes/'
outputPath = '../eCAMI/sig_cazymes_EC.csv'
output = {}


for file1 in os.listdir(directory_eCAMI):
    protein = file1
    print(protein)

    folderPath = directory_eCAMI + protein + '/'
    #print(folderPath)

    output[protein] = ""
    #print(output)

    for file2 in os.listdir(folderPath):
        #print(file2)
        inputPath = folderPath + file2
        input = open(inputPath, mode = "r")
    
        for line1 in input:
            if '>' in line1:
                line_split = line1.split('	')
                #print(line_split)
                line_EC = line_split[1:]
                #print(line_EC)

                if len(line_EC) > 1:
                    for entry_EC in line_EC:
                        entry_EC_clean = entry_EC.strip()
                        if entry_EC_clean in output[protein]:
                            continue
                        else:
                            output[protein] += (entry_EC_clean + '_')
                else:
                    entry = output.get(protein)
                    entry_EC_clean = line_EC.strip()
                    if entry_EC_clean in output[protein]:
                        continue
                    else:
                        output[protein] += (entry_EC_clean + '_')




df = pd.DataFrame([output])
df_flip = df.transpose()
df_flip.to_csv(outputPath)
