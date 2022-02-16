#!/bin/bash
# MUST BE IN PYTHON 3 VIRTENV!!!

### BELOW ARE PARAMETERS TO CHANGE
processors=20
inputDir=/home/glbrc.org/echiang3/Saline_MetaG/dbcan/sig/
outputDir=/home/glbrc.org/echiang3/Saline_MetaG/eCAMI/sig_cazymes/
eCAMIpath=/home/glbrc.org/echiang3/metag/eCAMI/
cd $eCAMIpath

for file in $inputDir*.ffn
    # Go through each file in the directory
do
    echo "Processing $file"

    fileName=${file##*/}
    #echo "$fileName"

    temp=${fileName%.*}
    #echo "$temp"

    sample=${temp%.*}
    #echo "$sample"

    protein=${temp##*.}
    #echo "$protein"

    outputPath="$outputDir""$sample"."$protein".txt
    #echo "$outputDir"
    echo "$outputPath"


    # Run eCAMI
    python prediction.py -input $file -kmer_db EC -output $outputPath -jobs $processors


    echo "Finished $file"

done