These scripts take cellranger bam output 'possorted_genome_bam.bam', filter viral reads into a new bam file, and sort viral reads by cell barcode to bin by cell population (cell barcode and cell population information is provided in meta data).
Output is a directory named 'sampleID' with bam files named cellpopname.bam containing WNV reads that originated from each cell type/population.  
If multiple bam files with different 'sampleID's in filebase are provided, multiple directories will be made, each named 'sampleID'. 
cellpopname.bam files can be used to identify viral variants within specific cell populations (LoFreq), depending on coverage.

samtools v1.23
sinto v0.10.1

Prepare cellranger output bams for viral read extraction:

1. rename cellranger output 'possorted_genome_bam.bam' to sampleID_possorted_genome_bam.bam where 'sampleID' exactly matches the sample ID in sc_meta: ```$ mv possorted_genome_bam.bam wnvMg3_possorted_genome_bam.bam```
2. optionally move renamed bam files to working directory with viralReadSubset_V2.sh OR copy viralReadSubset_V2.sh into the directory containing your input bam file
3. filter for and retain viral reads: ```$ ./viralReadSubset_V2.sh *.bam```
5. sort and index filtered bam files with samtools
6. move sorted bam files and bai files to new working directory containing scVariantID_V2.sh

create sc_meta.csv file by extracting meta data from merged, normalized, seurat object like so:

1. ```> meta <- merged.srt@meta.data```
2. subset meta data by infection condition (only infected samples will have virus reads)
3. select sample ID, cell barcode, and cell type columns 
4. remove extraneous sample ID appended to start of cell barcode: sample-XXXXXXXXXX-1 -> XXXXXXXXXX-1
5. write as csv file and move file to working directory with scVariantID_V2.sh

Sort viral reads by cell barcode:

1. ```$ ./scVariantID.sh *.bam```

Coverage in cellpopname.bam files can be checked by running ```$ samtools depth cellpopname.bam > output.depth``` and visualizing resulting depth file in scVariantID_coverage_plots.R
