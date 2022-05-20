#!/usr/bin/env bash

#SBATCH --time=10:00:00
#SBATCH -o convert-%j.out
#SBATCH -e convert-%j.err
#SBATCH --mail-user=brady.neeley@hsc.utah.edu
#SBATCH --mail-type=END
#SBATCH --account=pezzolesi-np
#SBATCH --partition=pezzolesi-np

#FILES=($(ls -1 *.cram))
#FILENAME=${FILES[$SLURM_ARRAY_TASK_ID]}
#echo "My input file is ${FILENAME}"

module load samtools

samtools view -H -o cramHead.txt /uufs/chpc.utah.edu/common/home/u0854535/sentieon_pipeline/fras1Crams/FS190273.cram
 

