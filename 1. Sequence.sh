mkdir targeted_seq
Cd targeted_seq
pwd

# Installation & update
sudo apt update 
sudo apt install sra-toolkit -y
sudo apt install bwa samtools bcftools fastqc trimmomatic -y

# Retrieve the sequence
prefetch SRR40443888
fasterq-dump SRR4044388 --split-files  

ls -lh 

# convert in compressed format
gzip SRR40443888_1.fastq
gzip SRR40443888_2.fastq
