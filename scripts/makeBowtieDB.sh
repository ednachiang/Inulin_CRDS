#!/bin/bash

### BELOW ARE PARAMETERS TO CHANGE
processors=20
cd exo_fasta_sep
shortReadDir=/home/glbrc.org/echiang3/Saline_MetaG/Trimmed/NoHost/


echo "There are $(ls | wc -l) fasta files in $(pwd)"

for i in *.fasta
do
    echo "Processing $i"
    outputPath="$i".bowtie.database

    # Create database from input fasta
    echo "Creating database from input fasta"
    bowtie2-build --seed 1 $i $outputPath

    # Map input reads to input fasta
    echo "Mapping input reads to database"
    inputR1="$shortReadDir""${i:0:5}".nohost.R1.fastq
    inputR2="$shortReadDir""${i:0:5}".nohost.R2.fastq
    outputSAM="${i:0:-5}"sam
    bowtie2 --sensitive-local -p $processors --seed 1 -x $outputPath -1 $inputR1 -2 $inputR2 -S $outputSAM

    # Convert SAM to BAM, using only mapped reads (unmapped reads are excluded)
    echo "Extracting mapped reads"
    outputBAM="${i:0:-5}"mapped.bam
    /opt/bifxapps/samtools/samtools view -@ $processors -bS -f 2 $outputSAM > $outputBAM

    # Sort BAM file to organize paired reads
    echo "Sorting reads"
    outputBAMsorted="${outputBAM:0:-3}"sorted
    /opt/bifxapps/samtools/samtools sort -@ $processors -n $outputBAM $outputBAMsorted

    # Convert BAM to fastq
    echo "Making fastq"
    outputBAMsorted="$outputBAMsorted".bam
    mappedReadsFastq="${i:0:-5}"mapped.fastq
    /opt/bifxapps/samtools/samtools bam2fq $outputBAMsorted > $mappedReadsFastq


    echo "Finished $i"
done