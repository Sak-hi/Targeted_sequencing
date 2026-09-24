# Quality control
fastqc SRR40443888_1.fastq.gz
fastqc SRR40443888_2.fastq.gz

# Trimming
fastp \
-i SRR40443888_1.fastq.gz \
-I SRR40443888_2.fastq.gz \
-o SRR40443888_R1.clean.fastq.gz \
-O SRR40443888_R2.clean.fastq.gz \
-h SRR40443888_fastp.html \
-j SRR40443888_fastp.json \
-w 2

# Quality control after trimming
fastqc \
SRR40443888_R1.clean.fastq.gz \
SRR40443888_R2.clean.fastq.gz

# Reference genome chr7
curl.exe -L "https://www.ncbi.nlm.nih.gov/sviewer/viewer.fcgi?id=NC_000007.14&db=nuccore&report=fasta&retmode=text" -o chr7.fa

# Index the chr7
bwa index chr7.fa

# Alignment
bwa mem -R "@RG\tID:SRR40443888\tSM:SRR40443888\tPL:ILLUMINA\tLB:ThyroidTargetedPanel\tPU:SRR40443888" chr7.fa SRR40443888_R1.clean.fastq.gz SRR40443888_R2.clean.fastq.gz > SRR40443888_chr7.sam
