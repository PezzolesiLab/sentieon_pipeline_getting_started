#!/usr/bin/env bash

#SBATCH --time=3-00:00:00
#SBATCH --nodes=1
#SBATCH -o pipelineKickOff-%j.out
#SBATCH -e pipelineKickOff-%j.err
#SBATCH --mail-user=brady.neeley@hsc.utah.edu
#SBATCH --mail-type=END
#SBATCH --account=pezzolesi-np
#SBATCH --partition=pezzolesi-np
#SBATCH --ntasks=6
#SBATCH --mem=32G

# this vvvv should be either 'resume' or 'new'
resume=$1
configFile=$2
# rename this vvvv to create a new directory for your project (i.e. if you want to start over without deleting what you've already done)
scratchDir="/scratch/general/lustre/$USER/testingThePipeline"
#var=$(cat nextflow.config | grep "scratch =")--|
#IFS="\"" read -ra varArr <<< $var              |- cant get to work yet
#scratchDir=${varArr[1]}                      --|
# IGNORE: rename this vvvv to change clusters (e.g. kingspeak, notchpeak, ember, lonepeak, etc.)
# IGNORE: SLURM_CLUSTERS="notchpeak"
# IGNORE: export SLURM_CLUSTERS

if [ -z $2 ]; then
    if [[ $resume == "resume" ]]; then
        if [ -d $scratchDir ]; then
            echo -e "\nResuming your previous run\n"
            cp ./sentieon.nf ./nextflow.config $scratchDir
            #cp -r ./bin $scratchDir
            cd $scratchDir
            nextflow run -with-report -with-trace -with-timeline -with-dag dag.html sentieon.nf -resume
        else
            echo "There's nothing to resume (scratch directory doesn't exist)"
        fi
    elif [[ $resume == "new" ]]; then
        if [ ! -d $scratchDir ]; then
            echo -e "\nStarting a new project\n"
            mkdir -p $scratchDir/{results/{fastp,fastqc,bqsr,vqsr,bam/{stats,coverage},gvcf,vcf/stats},bin}
            cp ./sentieon.nf ./nextflow.config $scratchDir
            cp -r ./bin $scratchDir
            cd $scratchDir
            nextflow run -with-report -with-trace -with-timeline -with-dag dag.html sentieon.nf
        else
            echo "A project already exists. Delete it and start over or resume it"
        fi
    else
        echo "Takes string argument 'resume' or 'new'"
    fi
else
    if [[ $resume == "resume" ]]; then
        if [ -d $scratchDir ]; then
            echo -e "\nResuming your previous run\n"
            cp ./sentieon.nf $configFile $scratchDir
            #cp -r ./bin $scratchDir
            cd $scratchDir
            nextflow -C $configFile run -with-report -with-trace -with-timeline -with-dag dag.html sentieon.nf -resume
        else
            echo "There's nothing to resume (scratch directory doesn't exist)"
        fi
    elif [[ $resume == "new" ]]; then
        if [ ! -d $scratchDir ]; then
            echo -e "\nStarting a new project\n"
            mkdir -p $scratchDir/{results/{fastp,fastqc,bqsr,vqsr,bam/{stats,coverage},gvcf,vcf/stats},bin}
            cp ./sentieon.nf $configFile $scratchDir
            cp -r ./bin $scratchDir
            cd $scratchDir
            nextflow -C $configFile  run -with-report -with-trace -with-timeline -with-dag dag.html sentieon.nf
        else
            echo "A project already exists. Delete it and start over or resume it"
        fi
    else
        echo "Takes string argument 'resume' or 'new'"
    fi
fi
