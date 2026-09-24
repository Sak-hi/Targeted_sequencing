# download VEP for annotation
git clone https://github.com/Ensembl/ensembl-vep.git 
cd ensembl-vep 

# install 
sudo apt install libdbi-perl -y 
perl -MDBI -e 'print "DBI installed successfully\n"' 

perl --version 
perl -MDBI -e 'print "DBI OK\n"' 
ls -lh INSTALL.pl 

sudo apt update 
sudo apt install cpanminus build-essential libmysqlclient-dev -y 
sudo cpanm DBD::mysql 
perl -MDBD::mysql -e 'print "DBD::mysql OK\n"' 

~/targeted_seq/ensembl-vep 
perl INSTALL.pl --AUTO a
./vep --help 

bcftools query -f '%CHROM\n' SRR40443888_chr7.filtered.vcf.gz | sort -u
bcftools view -h SRR40443888_chr7.filtered.vcf.gz | head -20
bcftools view -H SRR40443888_chr7.filtered.vcf.gz | head

bcftools query -f '%CHROM\t%POS\t%REF\t%ALT\t%FILTER\n' \
SRR40443888_chr7.filtered.vcf.gz | head -20

# check info/format
bcftools query \ 
-f '%CHROM\t%POS\t%REF\t%ALT\t%FILTER\t[%DP\t%AD\t%AF]\n' \ 
SRR40443888_chr7.filtered.vcf.gz 

# all variants from your filtered VCF that fall within the BRAF genomic region extract 
bcftools view \
-r NC_000007.14:140719327-140925199 \
SRR40443888_chr7.filtered.vcf.gz

# save the BRAF-region variants 
bcftools view \ 
-r NC_000007.14:140719327-140925199 \ 
SRR40443888_chr7.filtered.vcf.gz \ 
-Oz -o BRAF_region.vcf.gz 

# index it 
bcftools index BRAF_region.vcf.gz 

# annotation
 ./ensembl-vep/vep \
-i BRAF_region.vcf.gz \
-o BRAF_region_annotated.vcf \
--vcf \
--database \
--species homo_sapiens \
--assembly GRCh38 \
--symbol \
--canonical \
--force_overwrite

# see the variant record 
grep -v "^#" BRAF_region_annotated.vcf | head

# confirms that VEP added the CSQ annotation field. 
grep -n "CSQ" BRAF_region_annotated.vcf | head

# convert in txt format
bcftools query \ -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t%INFO/CSQ\n' \ BRAF_region_annotated.vcf > BRAF_VEP_annotations.txt 

grep '##INFO=<ID=CSQ' BRAF_region_annotated.vcf 

# easy to read
cftools +split-vep BRAF_region_annotated.vcf \
-d \
-f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t%SYMBOL\t%Consequence\t%IMPACT\t%HGVSc\t%HGVSp\t%CANONICAL\n' \
> BRAF_final_annotation.tsv

# add header
sed -i '1i CHROM\tPOS\tREF\tALT\tQUAL\tFILTER\tSYMBOL\tConsequence\tIMPACT\tHGVSc\tHGVSp\tCANONICAL' BRAF_final_annotation.tsv

# 
awk -F'\t' 'NR==1 || $11 != "."' BRAF_final_annotation.tsv | head -20
