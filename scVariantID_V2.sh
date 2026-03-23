#/bin/sh 
#Date: 12/30/25
#Author: Emily Fitzmeyer

# create sc_meta file by extracting meta data from merged, normalized, seurat object:
# meta <- merged.srt@meta.data
# subset by infection condition
# select sample ID, cell barcode, and cell type columns 
# remove extraneous sample ID appended to start of cell barcode:
# sample-XXXXXXXXXX-1 -> XXXXXXXXXX-1
# write as csv file

# filter cellranger output 'possorted_genome_bam.bam' for viral reads using grep "your_accession_number.1" 
# output should be named 'sampleID_possorted_genome_bam.bam' where 'sampleID' matches the sample ID in sc_meta
# example:
# samtools view possorted_genome_bam.bam | grep "NC_009942.1" > wnvMg3_possorted_genome_bam.bam
# input bam files and sc_meta file must be in working directory
# generate bam.bai files for filtered bams in working directory

# script fails if command fails 
set -e

# define arguments passed as 'file_base'
file_base=$@

# alert the user if input is not supplied
if [ $# == 0 ]
then
        echo -e "scVariantID>>>>> ERROR>>>>>
        Please provide input like so: ./this_script sample.bam"
fi

# print greeting if input is supplied
if [ $# -gt 0 ]
then
        echo -e "Processing sample: $file_base"
        date
fi


sc_meta="./sc_meta.csv"    

for file_base in ${file_base[@]}
do

# define sample ID from file_base
        sample_ID=${file_base/_sorted.bam/}
        echo -e "sample ID = $sample_ID"
        
# use sample ID to subset meta 
        grep "$sample_ID" $sc_meta > sample_meta.csv
        head -n 20 sample_meta.csv

# remove sample ID column from meta
        awk '{sub(/[^,]*,/,"")} 1' sample_meta.csv > sinto_sample_meta.csv
# convert csv to tsv with coreutils::tr
        tr ',' '\t' < sinto_sample_meta.csv > sinto_sample_meta.tsv
        head -n 20 sinto_sample_meta.tsv

# make output bam directory 
        mkdir $sample_ID
        output_dir=$sample_ID
        echo -e "$output_dir"

#filter barcodes with sinto
        sinto filterbarcodes -b $file_base -c sinto_sample_meta.tsv -p 1 --outdir $output_dir 
done

#say bye
echo -e "Done"
