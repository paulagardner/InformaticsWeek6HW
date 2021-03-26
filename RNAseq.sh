#!/bin/bash
#SBATCH --job-name=RNA    ## Name of job
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-20       ## number of tasts to launch (prefixes has 24 lines so 24)
#SBATCH --cpus-per-task=2  ## number of cores needed 

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load python/3.8.0
module load gatk/4.1.9.0
module load picard-tools/1.87
module load java/1.8.0
module load hisat2/2.2.1


inpath="~/EE283_files/pdgardne/RNAseq/"
# or pass the file name to the shell script, how would I do this?
file=$inpath"RNAprefixes.txt"
# is the file indexed for bwa?
ref="~/EE283_files/pdgardne/ref/dmel-all-chromosome-r6.13.fasta"
dir="~/EE283_files/pdgardne/RNAseq"
# here is a hint if you had a tab delimited input file
prefix=`head -n $SLURM_ARRAY_TASK_ID  ${file} | tail -n 1`
#samplename=`echo $prefix | sed -e "s/rawdata/bam/"` part left over from lauren's code


# alignments-- from liz's code 
hisat2 -p 2 -x $ref -1 ${inpath}rawdata/${prefix}_R.fq.gz -2 ${inpath}rawdata/${prefix}_F.fq.gz -S ${inpath}${prefix}.sam 
#maybe edit above to just be {prefix, as Lauren did?}

samtools view -bS -o ${inpath}${prefix}.bam ${inpath}${prefix}.sam 
samtools sort ${inpath}${prefix}.bam -o ${inpath}${prefix}.sorted.bam
samtools index ${inpath}${prefix}.sorted.bam
rm ${inpath}${prefix}.bam
rm ${inpath}${prefix}.sam


#to run this: sbatch ATACjob.sh (or whatever file name)
#to check: squeue -u pdgardne
#to see if you had errors: less the slurm output files you get. Especially suspicious if alignments run quickly
