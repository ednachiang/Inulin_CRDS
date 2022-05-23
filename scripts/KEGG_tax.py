import os
from unicodedata import bidirectional
	# Import os to iterate over files in a directory
import pandas as pd
    # Import pandas to use dataframes

##### CHANGE THESE PARAMETERS ACCORDINGLY
directoryFile = 'test/ko00001.keg'
directoryOutput = 'test/'

Adelim = " "
Bdelim = "  "
Cdelim = "    "
Ddelim = "      "

def makeKeggTax(inputDir, outputDir):

    input = open(inputDir, mode = "r")
    dictAB = {}
    dictBC = {}
    dictCD = {}

    for line1 in input.readlines():
        if("A" in line1[0]):
            AID = line1[1:6]
            dictAB[AID] = "NA"
        elif("B" in line1[0]):
            line1Split = line1.split(Bdelim)
            BID = line1Split[1]
            BID = BID[0:5]
            dictAB[AID] = BID
            dictBC[BID] = "NA"
        elif("C" in line1[0]):
            line1Split = line1.split(Cdelim)
            CID = line1Split[1]
            CID = CID[0:5]
            dictBC[BID] = CID
            dictCD[CID] = "NA"
        elif("D" in line1[0]):
            line1Split = line1.split(Ddelim)
            DID = line1Split[1]
            DID = DID[0:5]
            dictCD[CID] = DID
        else:
            print(line1)







makeKeggTax(directoryFile, directoryOutput)