#!/bin/bash

### BELOW ARE PARAMETERS TO CHANGE
processors=20
inputDir=/mnt/bigdata/linuxhome/echiang3/Inulin_MetaG/dbcan/sig/
outputDir=/home/glbrc.org/echiang3/Inulin_MetaG/kaiju/sig_cazymes/
cd $outputDir


#echo "There are $(ls | wc -l) ffn files in $inputDir"

for i in $inputDir*.ffn
do
    echo "Processing $i"

    fileName=${i##*/}
    #echo "$fileName"

    temp=${fileName%.*}
    #echo "$temp"

    sample=${temp%.*}
    #echo "$sample"

    protein=${temp##*.}
    #echo "$protein"

    outputPath="$outputDir""$sample"."$protein".kaiju.output
    #echo "$outputPath"

    echo "Creating Kaiju output"
    /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -f /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nr_euk/kaiju_db_nr_euk.fmi -i $i -o $outputPath -z $processors -E 1e-05 -v 

    echo "Finished $i"
done