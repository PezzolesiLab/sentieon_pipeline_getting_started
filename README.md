# The Sentieon Pipeline

The bones for the Sentieon pipeline come from the Yandell lab at the University of Utah. It is set up to run on the CHPC notchpeak server. My predecessor in the Pezzolesi lab, Scott Frodsham, did some tweaking and it has ran great for the lab. I also have made a couple of changes to it affecting runtime and fastq input. The purpose of this repository however, is to provide some background and resources on the pipeline as well as a walkthrough on running this ready to go out of the box variant calling pipeline.
<br/>
<br/>

# Quick Start

## FASTQs

All of the fastq files that you want to push through the pipeline need to be in the same directory. If the fastqs are in different directories you can create symbolic links that are all in the same directory for the fastqs of interest.

## Config File

You need a config file to run the pipeline. You can create a new one if you'd like, or you can use one of the ones provided in the `./configs` directory. The config file you end up using must be named `nextflow.config` and must be in the same directory as the `sentieon.nf` file. You'll need to rename and move one of these files in order to run the pipeline. You should execute a command similar to this:

`cp ./bin/demux.config ./nextflow.config`

This `nextflow.config` file and the `runSentieonPL.sh` script should be the only two files you have to edit.

The `nextflow.config` file contains all of the parameters specific to your project that nextflow needs to successfully run your
data through to the end. In the `params` section, you'll want to make sure that the following variables are set to work with your
data: `project`, `dataDir`, `isDemuxNeeded`, `barcodeFile`, `sampleKey`, `isIntervalNeeded`, and `bedFile`. In the `process`
section, you should only change the `clusterOptions` and the `scratch` variables. The `clusterOptions` variable sets the SLURM parameters for each
job that is scheduled to a CHPC cluster. The `scratch` directory specifies the directory where the heavy lifting will be done and where the end results of the pipeline. Be sure that the `scratch` variable matches the `scratchDir` variable in the `runSentieonPL.sh` script.

The pipeline is designed to run on the Pezzolesi node (notch026). Our node has 32 CPUs on it. By using the "shared" feature, we can schedule jobs on each of these CPUs individually or on groups of them. Once it's running, nextflow should run on a small set of CPUs, the subsequent jobs will be scheduled using the remaining CPUs. The command that controls this behavior is `clusterOptions`.

## runSentieonPL.sh File

You need to make sure that the `scratchDir` variable in this file matches the `scratch` variable you specify in your `nextflow.config` file.

## Starting the Pipeline

The pipeline is started through the `runSentieonPL.sh` script by issuing one of the two commands below from the command line:

`sbatch runSentieonPL.sh new`

 or 

`sbatch runSentieonPL.sh resume`

## A Couple of Final Notes

The pipeline is set to run for 5 days. If you think it'll take longer than that then modify the `--time` flag in the
`runSentieonPL.sh` SLURM header.

The pipeline stalls out after finishing (still can't get it to recognize when it's done), so you'll have to cancel the job
yourself in order to free up the Pezzolesi node for others to use.

<br/>

# Background

#### Overview from the Sentieon webpage:
>Sentieon® provides complete solutions for secondary DNA/RNA analysis for a variety of sequencing platforms, including short and long reads. Our software improves upon BWA, STAR, Minimap2, GATK, HaplotypeCaller, Mutect, and Mutect2 based pipelines and is deployable on any generic-CPU-based computing system. Our products have been extensively tested and validated by customers, and have processed millions of samples totaling over 900 petabases of DNA.

We reference the GATK best practices workflow as the workflow is essentially the same and the tools are comparable. GATK is publicly available and Sentieon is the commercial product.

#### Helpful resources:

GATK Best Practices and Forum
Best Practices - https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-

Mark Duplicates - https://gatk.broadinstitute.org/hc/en-us/articles/360057439771-MarkDuplicates-Picard-

BQSR Explanation - https://gatk.broadinstitute.org/hc/en-us/articles/360035890531-Base-Quality-Score-Recalibration-BQSR-

Joint Calling - https://gatk.broadinstitute.org/hc/en-us/articles/360035890431-The-logic-of-joint-calling-for-germline-short-variants

GVCF - https://gatk.broadinstitute.org/hc/en-us/articles/360035531812-GVCF-Genomic-Variant-Call-Format

VQSR Explanation - https://gatk.broadinstitute.org/hc/en-us/articles/360035531612-Variant-Quality-Score-Recalibration-VQSR-

Forum - https://gatk.broadinstitute.org/hc/en-us/community/topics

## Dependencies

### Install
 * annovar (currently pointing to my copy of the .pl script but the pezzolesi-group1 copy of the annovar DB)
 * fastp/0.19.6
 * multiqc/1.7
 * cutadapt/1.6 or higher
 * fastq-multx/1.3.1

### Modules Needed
 * bcftools/1.7
 * bgzip/1.7
 * samtools/1.9
 * tabix/1.7
 * sentieon/201711.05

 Example loading bcftools: `ml bcftools/1.7` or `module load bcftools/1.7`
