ls -lh chr7.fa* 

# create index file 
samtools faidx chr7.fa 

# create chr7.dict file if not present
java -Xmx2g -jar ~/targeted_seq/picard.jar CreateSequenceDictionary \ 
R=chr7.fa \ 
O=chr7.dict 

# gatk install for variant calling
wget -O gatk-4.7.0.0.zip https://github.com/broadinstitute/gatk/releases/download/4.7.0.0/gatk-4.7.0.0.zip
ls -lh gatk-4.7.0.0.zip 

# unzip file
unzip gatk-4.7.0.0.zip 

cd gatk-4.7.0.0 
./gatk --version 
./gatk Mutect2 --help 
java -version 

cd ~/targeted_seq 

# run variant calling
~/targeted_seq/gatk-4.7.0.0/gatk Mutect2 \
-R chr7.fa \
-I SRR40443888_chr7.marked.bam \
-O SRR40443888_chr7.unfiltered.vcf.gz

ls -lh SRR40443888_chr7.unfiltered.vcf.gz*

# filter file
~/targeted_seq/gatk-4.7.0.0/gatk FilterMutectCalls \
-R chr7.fa \
-V SRR40443888_chr7.unfiltered.vcf.gz \
-O SRR40443888_chr7.filtered.vcf.gz

# count variants that pass
 zgrep -v "^#" SRR40443888_chr7.filtered.vcf.gz | \
awk '$7=="PASS"' | wc -l
>>2377

# count all variants
zgrep -v "^#" SRR40443888_chr7.filtered.vcf.gz | wc -l 
>>37269

# view first few
zgrep -v "^#" SRR40443888_chr7.filtered.vcf.gz | head 

