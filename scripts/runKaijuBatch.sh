#!/bin/bash

### BELOW ARE PARAMETERS TO CHANGE
processors=20
inputDir=/home/glbrc.org/echiang3/Saline_MetaG/eCAMI/endo/
outputDir=/home/glbrc.org/echiang3/Saline_MetaG/kaiju/endo/
protein=endo
cd $outputDir


echo "There are $(ls | wc -l) fastq files in $inputDir"

for i in $inputDir*.fastq
do
    echo "Processing $i"
    sample=$(echo $i | cut -d'/' -f 8)
    outputPath="$outputDir""${sample:0:5}".endo.kaiju.output

    echo "Creating Kaiju output"
    /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -f /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nr_euk/kaiju_db_nr_euk.fmi -i $i -o $outputPath -z $processors -E 1e-05 -v 

    echo "Creating Kaiju tables"
    for taxon in */
    do
        echo "${taxon:0:-1}"
        outputFile="$outputDir""$taxon""${sample:0:5}"."$protein"."${taxon:0:-1}".tsv
        /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju2table -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -n /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/names.dmp -r ${taxon:0:-1} -o $outputFile $outputPath -l superkingdom,phylum,class,order,family,genus,species -v
    done

    echo "Finished $i"
done