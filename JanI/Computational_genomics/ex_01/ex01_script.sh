#!/bin/bash

#first argument determines the prefix of the file
#second one determines if the script has to split anything in the chromosome column,
#if it has to split, set second argument to 0

zcat data/$1_mrna.fa.gz | \
  infoseq -sequence fasta::stdin \
          -outfile data/$1_mrna.lengc.tbl \
          -noheading -only -name -length -pgc

echo "Working on all $1 files"

zcat data/$1_all_mrna.txt.gz|sed 's/chrX_/chrUn/'|sed 's/chrY_/chrUn/'|gzip > data/$1_mrna_file.txt.gz

zcat data/$1_mrna_file.txt.gz|cut -f10,11,15 > data/$1_chr_data.txt


splitCHR=$2 

if [ "$splitCHR" -eq 0 ]; then #case of dmel, and any other that includes chromosomes with an added value
	echo "Executing chromosome splitting fix"
	cut -f1 -d"_" data/$1_chr_data.txt >data/temp.txt  #| head -n 94200|tail  #
	awk '{ print $1, $2, substr($3, 1, 4), substr($3, 5) }' data/temp.txt > data/$1_chr_data.txt

	sed -i 's/ $/ NA/' data/$1_chr_data.txt
	sed -i 's/chrU n/chrU NA/g' data/$1_chr_data.txt

	#
	rm data/temp.txt
else
	echo "No split chromosomes to fix"
fi

