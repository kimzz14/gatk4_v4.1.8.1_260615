############################################################################################
readID=$1
############################################################################################
#check
if [ -z ${readID} ]; then
    echo "readID is empty."
    exit 1
fi

#command
echo "bash pipe/stat.sh ${readID}" >> stat.sh
while read -r chrom chromLen rest; do
    echo "bash pipe/run_gatk.sh 24 ${readID} ${chrom}" >> run0001.sh
done < "db/ref.fa.fai"
