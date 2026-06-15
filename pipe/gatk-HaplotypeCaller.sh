############################################################################################
threadN=$1
readID=$2
chrom=$3
############################################################################################
#check
if [ -z ${threadN} ]; then
    echo "threadN is empty."
    exit 1
fi

if [ -z ${readID} ]; then
    echo "readID is empty."
    exit 1
fi

if [ -z ${chrom} ]; then
    echo "chrom is empty."
    exit 1
fi

#set gatk
if [[ -x /s3/opt/soft/gatk/gatk ]]; then
    GATK="/s3/opt/soft/gatk/gatk"
elif command -v samtools >/dev/null 2>&1; then
    GATK="$(command -v gatk)"
else
    echo "ERROR: gatk not found." >&2
    exit 1
fi

#command
${GATK} --java-options "-Djava.io.tmpdir=./tmp" HaplotypeCaller \
    -ERC        GVCF \
    --reference db/ref.fa \
    --intervals ${chrom} \
    --input     result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam \
    --output    result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.HaplotypeCaller.${chrom}.g.vcf \
    1>          result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.HaplotypeCaller.${chrom}.g.vcf.log \
    2>          result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.HaplotypeCaller.${chrom}.g.vcf.err
