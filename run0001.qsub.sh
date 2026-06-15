#!/bin/sh

#PBS -N gvcf-CS-A00010
#PBS -q nabic
#PBS -l select=100:ncpus=24
#PBS -e ./pbs.log
#PBS -o ./pbs.err

cd $PBS_O_WORKDIR
module use /s3/opt/modulefiles/
module load java/22

aprun -n 100 -N 1 -d 24 bash batch/aprun.sh run0001
