############################################################################################
readID=$1
############################################################################################
#check
if [ -z ${readID} ]; then
    echo "readID is empty."
    exit 1
fi

#command
total=0
while read -r chrom chromLen rest; do
    lastPos=$(tail -n 1 result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.HaplotypeCaller.${chrom}.g.vcf | cut -f2)
    total=$((total + lastPos))
done < "db/ref.fa.fai"
echo $readID $total
