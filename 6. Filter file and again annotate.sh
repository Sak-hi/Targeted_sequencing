# first row missense
awk -F'\t' '$8 ~ /missense_variant/ {print; exit}' BRAF_final_annotation.tsv 

# BRAF variant
bcftools +split-vep BRAF_region_annotated.vcf \ -d \ -f '%CHROM\t%POS\t%REF\t%ALT\t%Consequence\t%SYMBOL\t%Feature\t%HGVSc\t%HGVSp\t%Amino_acids\t%Protein_position\n' \ | grep 'missense_variant' | head -10 

# check VEP's HGVS options 
./ensembl-vep/vep --help | grep -E -- '--hgvs|--hgvsg|--transcript_version' 

./ensembl-vep/vep \ 
-i BRAF_region.vcf.gz \ 
-o BRAF_region_annotated_hgvs.vcf \ 
--vcf \ 
--database \ 
--species homo_sapiens \ 
--assembly GRCh38 \ 
--symbol \ 
--canonical \ 
--hgvs \ 
--force_overwrite 

# HGVS table
bcftools +split-vep BRAF_region_annotated_hgvs.vcf \ -d \ -f '%CHROM\t%POS\t%REF\t%ALT\t%QUAL\t%FILTER\t%SYMBOL\t%Consequence\t%IMPACT\t%Feature\t%HGVSc\t%HGVSp\t%Amino_acids\t%Protein_position\t%CANONICAL\n' \ | awk -F'\t' '$11 != "." && $12 != "."' \ > BRAF_HGVS_variants.tsv 

# add header
sed -i '1i CHROM\tPOS\tREF\tALT\tQUAL\tFILTER\tSYMBOL\tConsequence\tIMPACT\tFeature\tHGVSc\tHGVSp\tAmino_acids\tProtein_position\tCANONICAL' BRAF_HGVS_variants.tsv 

# count 
tail -n +2 BRAF_HGVS_variants.tsv | wc -l 

# only missense / SNV variants
awk -F'\t' '
NR==1 || ($3 ~ /^[ACGT]$/ && $4 ~ /^[ACGT]$/ && $8 ~ /(^|&)missense_variant(&|$)/)
' BRAF_HGVS_variants.tsv > BRAF_missense_SNVs.tsv

# count
tail -n +2 BRAF_missense_SNVs.tsv | wc -l

# apply canonical filter to narrow down
awk -F'\t' 'NR==1 || $15=="YES"' BRAF_missense_SNVs.tsv > BRAF_canonical_missense_SNVs.tsv 

# count
tail -n +2 BRAF_canonical_missense_SNVs.tsv | wc -l 

# apply pass filter to narrow down more
awk -F'\t' 'NR==1 || $6=="PASS"' BRAF_canonical_missense_SNVs.tsv > BRAF_priority_SNVs.tsv 

# count
tail -n +2 BRAF_priority_SNVs.tsv | wc -l 
