def make_qsub(keyword, subID, jobN):
    return f'''#!/bin/sh

#PBS -N map-{keyword}-{subID}
#PBS -q nabic
#PBS -l select={jobN}:ncpus=24
#PBS -e ./pbs.log
#PBS -o ./pbs.err

cd $PBS_O_WORKDIR
module use /s3/opt/modulefiles/

aprun -n {jobN} -N 1 -d 24 bash batch/aprun.sh run0001
'''

chrom_LIST = []
fin = open('db/ref.fa.fai')

for line in fin:
    chrom = line.rstrip('\n').split('\t')[0]
    chrom_LIST += [chrom]
fin.close()

keyword = 'AT'
input_subID = 'A00000'
jobN = 100


fout = open('run0001.parallel.qsub.sh', 'w')
fout.write(f'''#!/bin/sh

#PBS -N map-{keyword}-{input_subID}
#PBS -q nabic
#PBS -l select={jobN}:ncpus=24
#PBS -e ./pbs.log
#PBS -o ./pbs.err

cd $PBS_O_WORKDIR
module use /s3/opt/modulefiles/

aprun -n {jobN} -N 1 -d 24 bash batch/aprun.sh run0001
''')
fout.close()


fout = open('run0001.sh', 'w')
fin = open('../read.info')
for line in fin:
    projectID, subID, readID, path = line.rstrip('\n').split('\t')

    if subID != input_subID: continue

    for chrom in chrom_LIST:
        fout.write(f'bash pipe/run_gatk.sh 24 {readID} {chrom}\n')
fin.close()
fout.close()

fout = open('stat.sh', 'w')
fin = open('../read.info')
for line in fin:
    projectID, subID, readID, path = line.rstrip('\n').split('\t')

    if subID != input_subID: continue

    for chrom in chrom_LIST:
        fout.write(f'bash pipe/stat.sh {readID}\n')
fin.close()
fout.close()