############################################################################################
threadN=$1
chrom=$2
readID=$3
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

#command
bash pipe/gatk-AddOrReplaceReadGroups.sh ${threadN} ${readID} ${chrom}
bash pipe/gatk-HaplotypeCaller.sh        ${threadN} ${readID} ${chrom}
