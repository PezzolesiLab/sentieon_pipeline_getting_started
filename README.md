# The Sentieon Pipeline

The bones for the Sentieon pipeline come from the Yandell lab at the University of Utah. It is set up to run on the CHPC notchpeak server. My predecessor in the lab, Scott Frodsham, did some tweaking and it has been great. I also have made a couple of changes to it affecting runtime and fasta/fastq input. The purpose of this repository however, is to provide some background and resources on the pipeline as well as a walkthrough on running this ready to go out of the box variant calling pipeline.
<br/>
<br/>

## Getting Started

### Input Files

All of the fastq or bam files that you want to push through the pipeline need to be in the same directory. If the fastqs or bams are in different directories you can create symbolic links that are all in the same directory for the fastqs of interest. You should not try and move or copy the files. Use a command like the following:

`ln -s /absolute/path/to/fastqs/*.fastq.gz /absolute/path/to/new/directory`

The `nextflow.config` file and the `runSentieonPL.sh` script should be the only two files you have to edit.

You need a config file to run the pipeline. You can create a new one if you'd like, or you can use one of the ones provided in the `configs` directory. I would make a copy of an exisiting config matching closely to your data (WGS, WES, TargSeq, etc...) and tweak it as needed. Your new config can stay in the `configs` directory. Copying an existing config is quite simple and is done like this:

`cd configs`
`cp existing.config yourNewConfig.config`

### Changing the config's parameters UPDATE THIS
The `nextflow.config` file contains all of the parameters specific to your project that nextflow needs to successfully run your
data through to the end. In the `params` section, you'll want to make sure that the following variables are set to work with your
data: `project`, `dataDir`, `isDemuxNeeded`, `barcodeFile`, `sampleKey`, `isIntervalNeeded`, and `bedFile`. In the `process`
section, you should only change the `clusterOptions` and the `scratch` variables. The `clusterOptions` variable sets the SLURM parameters for each
job that is scheduled to a CHPC cluster. The `scratch` directory specifies the directory where the heavy lifting will be done and where the end results of the pipeline. Be sure that the `scratch` variable matches the `scratchDir` variable in the `runSentieonPL.sh` script.

The pipeline is designed to run on the Pezzolesi node (notch026) and the notchpeak general environment allocation nodes. The command that controls this behavior is `clusterOptions`.

### Changing the runSentieonPL.sh file
You need to make sure that the `scratchDir` variable in this file matches the `scratch` variable you specify in your `nextflow.config` file.

## Starting the Pipeline

The pipeline is started through the `runSentieonPL.sh` script by issuing one of the two commands below from the command line depending on whether you have ran the pipeline for this project before:

`sbatch runSentieonPL.sh new /path/to/sentieon/pipeline/configs/yourNewConfig.config`

 or 

`sbatch runSentieonPL.sh resume /path/to/sentieon/pipeline/configs/yourNewConfig.config`

Make sure you include the [absolute path](https://www.geeksforgeeks.org/absolute-relative-pathnames-unix/) to the config file in your command instead of a relative path.

## A Couple of Final Notes

The pipeline is set to run for 5 days. If you think it'll take longer than that then modify the `--time` flag in the
`runSentieonPL.sh` SLURM header. The max walltime can be set for 7 hours. Contact the CHPC if you need longer than that or if you can resume the pipeline if it times out and that works, that could be an option too.

<br/>

# Additional Background on the Pipeline

#### Overview from the Sentieon webpage:
>Sentieon® provides complete solutions for secondary DNA/RNA analysis for a variety of sequencing platforms, including short and long reads. Our software improves upon BWA, STAR, Minimap2, GATK, HaplotypeCaller, Mutect, and Mutect2 based pipelines and is deployable on any generic-CPU-based computing system. Our products have been extensively tested and validated by customers, and have processed millions of samples totaling over 900 petabases of DNA.

We reference the GATK best practices workflow as the workflow is essentially the same and the tools are comparable. GATK is publicly available and Sentieon is the commercial product.

#### Helpful resources for understanding the processes:

GATK Best Practices and Forum
Best Practices - https://gatk.broadinstitute.org/hc/en-us/articles/360035535932-Germline-short-variant-discovery-SNPs-Indels-

Mark Duplicates - https://gatk.broadinstitute.org/hc/en-us/articles/360057439771-MarkDuplicates-Picard-

BQSR Explanation - https://gatk.broadinstitute.org/hc/en-us/articles/360035890531-Base-Quality-Score-Recalibration-BQSR-

Joint Calling - https://gatk.broadinstitute.org/hc/en-us/articles/360035890431-The-logic-of-joint-calling-for-germline-short-variants

GVCF - https://gatk.broadinstitute.org/hc/en-us/articles/360035531812-GVCF-Genomic-Variant-Call-Format

VQSR Explanation - https://gatk.broadinstitute.org/hc/en-us/articles/360035531612-Variant-Quality-Score-Recalibration-VQSR-

Forum - https://gatk.broadinstitute.org/hc/en-us/community/topics

## Dependencies UPDATE LIST

### Install
**I install these in a conda/mamba environment called sentieon, then activate it when running the pipeline**
 * annovar (currently pointing to my copy of the .pl script but the pezzolesi-group1 copy of the annovar DB)
 * fastp/0.19.6
 * cutadapt/1.6 or higher
 * fastq-multx/1.3.1
 * multiqc/1.7

### Modules Needed
 * bcftools/1.7
 * bgzip/1.7
 * samtools/1.9
 * tabix/1.7
 * sentieon/201711.05 (Auto-loaded, don't worry about this one)

 Example loading bcftools: `ml bcftools/1.7` or `module load bcftools/1.7`
