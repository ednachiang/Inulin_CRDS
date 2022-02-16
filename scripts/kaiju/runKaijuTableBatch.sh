#!/bin/bash

### BELOW ARE PARAMETERS TO CHANGE
processors=20
inputDir=/home/glbrc.org/echiang3/Saline_MetaG/kaiju/sig_cazymes/
#outputDir=/home/glbrc.org/echiang3/Saline_MetaG/kaiju/sig_cazymes/
#protein=all_shortreads
taxonomy=("phylum" "class" "order" "family" "genus" "species")
cd $inputDir

for folder in $inputDir*/
    # Go through each folder in the directory
do
    echo "Processing $folder"
    protein=$(echo ${folder: -5})
    protClean=$(echo $protein | tr -d '/')
    protClean=$(echo $protClean | tr -d '.')
    #echo "$protClean"

    for sample in $folder*output
        # Go through each kaiju.output file
    do
        echo "$sample"
        sampName=$(echo ${sample: -23:-17})
        sampClean=$(echo $sampName | tr -d '/')
        sampClean=$(echo $sampClean | tr -d '.')
        #echo "$sampClean"
        echo "Creating Kaiju tables"

        for taxon in "${taxonomy[@]}"
        do
            echo "$taxon"
            mkdir "$folder""$taxon"
            outputFile="$folder""$taxon"/"$sampClean"."$protClean"."$taxon".tsv
            echo "$outputFile"
            /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju2table -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -n /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/names.dmp -r $taxon -o $outputFile $sample -l superkingdom,phylum,class,order,family,genus,species -v
        done
    done
    echo "Finished $folder"
done