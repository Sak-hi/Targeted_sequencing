# convert SAM to BAM
samtools view -bS SRR40443888_chr7.sam > SRR40443888_chr7.bam

# sort the BAM
samtools sort SRR40443888_chr7.bam -o SRR40443888_chr7.sorted.bam

# index the sorted BAM
samtools index SRR40443888_chr7.sorted.bam

# read group check
samtools view -H SRR40443888_chr7.sorted.bam | grep '^@RG'

# check BAM statistics
samtools flagstat SRR40443888_chr7.sorted.bam

# get mapping percentage
samtools stats SRR40443888_chr7.sorted.bam > SRR40443888_chr7.stats.txt

# check mapping quality
samtools view -c -q 20 SRR40443888_chr7.sorted.bam

# depth
samtools depth SRR40443888_chr7.sorted.bam > SRR40443888_chr7.depth.txt

# average depth
awk '{sum+=$3; count++} END {print "Average depth:", sum/count}' SRR40443888_chr7.depth.txt

# install picard
wget -O picard.jar https://github.com/broadinstitute/picard/releases/latest/download/picard.jar
ls -lh picard.jar 
java -jar ~/targeted_seq/picard.jar MarkDuplicates --version 

# if java not install
sudo apt install openjdk-17-jre -y 
java -jar ~/targeted_seq/picard.jar MarkDuplicates --version

# Mark picard
java -Xmx4g -jar ~/targeted_seq/picard.jar MarkDuplicates \
I=SRR40443888_chr7.sorted.bam \
O=SRR40443888_chr7.marked.bam \
M=SRR40443888_chr7.dup_metrics.txt

# index bam file
samtools index SRR40443888_chr7.marked.bam

# check bam
samtools flagstat SRR40443888_chr7.marked.bam 

# check bam stats
samtools stats SRR40443888_chr7.marked.bam > SRR40443888_chr7.marked.stats.txt
