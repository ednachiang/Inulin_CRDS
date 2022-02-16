#!/bin/bash

### BELOW ARE PARAMETERS TO CHANGE
processors=20
inputDir=/mnt/bigdata/linuxhome/echiang3/Saline_MetaG/dbcan/sig/
outputDir=/home/glbrc.org/echiang3/Saline_MetaG/kaiju/sig_cazymes/
#protein=exo
cd $outputDir


#echo "There are $(ls | wc -l) ffn files in $inputDir"

for i in $inputDir*.ffn
do
    echo "Processing $i"
    sample=$(echo $i | cut -d'/' -f 9)
    echo "$sample"
    outputPath="$outputDir""${sample:0:10}".kaiju.output
    echo "$outputPath"

    echo "Creating Kaiju output"
    /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -f /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nr_euk/kaiju_db_nr_euk.fmi -i $i -o $outputPath -z $processors -E 1e-05 -v 

    #echo "Creating Kaiju tables"
    #for taxon in */
    #do
    #    echo "${taxon:0:-1}"
    #    outputFile="$outputDir""$taxon""${sample:0:5}"."$protein"."${taxon:0:-1}".tsv
    #    /home/glbrc.org/echiang3/metag/kaiju/bin/kaiju2table -t /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/nodes.dmp -n /home/glbrc.org/echiang3/metag/kaiju/kaiju.db/names.dmp -r ${taxon:0:-1} -o $outputFile $outputPath -l superkingdom,phylum,class,order,family,genus,species -v
    #done

    echo "Finished $i"
done