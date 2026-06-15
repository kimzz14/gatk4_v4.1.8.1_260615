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

#set samtools
if [[ -x /s3/opt/bin/samtools ]]; then
    SAMTOOLS="/s3/opt/bin/samtools"
elif command -v samtools >/dev/null 2>&1; then
    SAMTOOLS="$(command -v samtools)"
else
    echo "ERROR: samtools not found." >&2
    exit 1
fi

#command
mkdir -p result/${readID}.bwa-memT001.fixmate.sorted.byChrom

${GATK} --java-options "-Djava.io.tmpdir=./tmp" AddOrReplaceReadGroups \
--INPUT           ../../../bam/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.sorted.${chrom}.bam \
--OUTPUT                result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam \
--SORT_ORDER            coordinate \
--MAX_RECORDS_IN_RAM    1280000 \
--VALIDATION_STRINGENCY LENIENT \
--RGID                  ${readID} \
--RGLB                  ${readID}_LIB \
--RGPL                  ILLUMINA \
--RGPU                  NONE \
--RGSM                  ${readID} \
1>                      result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam.log \
2>                      result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam.err

${SAMTOOLS} index \
    --threads ${threadN} \
    -c result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam \
    1> result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam.csi.log \
    2> result/${readID}.bwa-memT001.fixmate.sorted.byChrom/${readID}.bwa-memT001.fixmate.RGsorted.${chrom}.bam.csi.err
