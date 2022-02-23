#!/bin/bash

### BELOW ARE PARAMETERS TO CHANGE
processors=20
inputDir=/home/glbrc.org/echiang3/Inulin_MetaG/kaiju/sig_cazymes/
taxonomy=("phylum" "class" "order" "family" "genus" "species")
cd $inputDir

for folder in $inputDir*/
    # Go through each folder in the directory
do
    echo "Processing $folder"

    for sample in $folder*output
        # Go through each kaiju.output file
    do
        #echo "$sample"

        fileName=${sample##*/}
        #echo "$fileName"

        temp1=${fileName%.*}
        #echo "$temp1"
        temp2=${temp1%.*}
        #echo "$temp2"


        sampName=${temp2%.*}
        #echo "$sampName"

        protein=${temp2##*.}
        #echo "$protein"

        echo "Creating Kaiju tables"

        for taxon in "${taxonomy[@]}"
        do
            echo "$taxon"
            mkdir "$folder""$taxon"
                # After this folder is made, there'll be an error that says the folder already exists.
            outputFile="$folder""$taxon"/"$sampName"."$protein"."$taxon".tsv
            echo "$outputFile"

            /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju2table -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -n /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/names.dmp -r $taxon -o $outputFile $sample -l superkingdom,phylum,class,order,family,genus,species -v
        done
    done
    echo "Finished $folder"
done