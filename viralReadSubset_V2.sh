#/bin/sh
#Date: 2/12/26
#Author: Emily Fitzmeyer

# Define arguments passed as 'file_base'
file_base=$@

# Alert user if input is not supplied
if [ $# == 0 ]
then
        echo -e "viralReadSubset>>>>> ERROR>>>>>
        Please provide input like so: ./this_script sample.bam"
fi

# Print greeting if input is supplied
if [ $# -gt 0 ]
then
        echo -e "Processing sample: $file_base"
        date
fi

for file_base in ${file_base[@]}
do

    # Generate the output filenames
    filtered=${file_base/_possorted_genome_bam.bam/_filtered.bam}
    sorted=${file_base/_possorted_genome_bam.bam/_sorted.bam}

	# copy first line of header into output file
	samtools view -h $file_base | head -1 > $filtered

	# find line "@SQ	SN:NC_009942.1	LN:11029" 
	# add to output file along with the 6 lines that follow it (this is the bam header) 
	samtools view -h $file_base | grep -A 6 "SN:NC_009942.1" >> $filtered

	# grep and append to output file all lines containing "NC_009942.1" - these are the WNV reads 
	samtools view $file_base | grep "NC_009942.1" >> $filtered

	# New/Old version - - - - - - - - - - -
	
	# # Get header from bam file
	# samtools view -H $file_base > $header
	
	# # Extract WNV reads from bam file
	# samtools view $file_base | grep "NC_009942.1" | cat $header - | samtools view -Sb - > $filtered

	# - - - - - - - - - - - - - - - - - - - 

	# Sort new bam file
	samtools sort -m 5G $filtered > $sorted
	
	# Index new bam file
	samtools index $sorted
	
done

# Say bye
echo -e "Done"
