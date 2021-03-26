#!/bin/bash
#SBATCH --job-name=ATAC     ## Name of job
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-24       ## number of tasts to launch (prefixes has 24 lines so 24)
#SBATCH --cpus-per-task=2  ## number of cores needed 

#now going to try to put this file in the week 7 repo you added to your home directory for ATACseq and run the script from 
#there so you can push everything to github. There may be another way to do it but this way would be pretty 'clean' too

module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87

inpath="/data/class/ecoevo283/pdgardne/ATACseq/" #note that you could probably also use the path
#~/EE283_files/pdgardne/DNAseq/

# or pass the file name to the shell script, how would I do this?
file=$inpath"ATACprefixes.txt"
# is the file indexed for bwa?
ref="/data/class/ecoevo283/pdgardne/ref/dmel-all-chromosome-r6.13.fasta"

#here is a hint if you had a tab delimited input file
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`
samplename=`echo $prefix | sed -e "s/rawdata/bam/"`
idname=`echo $prefix | cut -d "/" -f 3 | cut -d "_" -f 1`


# alignments
bwa mem -t 2 -M $ref ${prefix}_F.fq.gz ${prefix}_R.fq.gz | samtools view -bS - > $samplename.bam
samtools sort $samplename.bam -o $samplename.sort.bam
# GATK likes readgroups
java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=$samplename.sort.bam O=$samplename.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$idname RGSM=$idname VALIDATION_STRINGENCY=LENIENT
samtools index $samplename.RG.bam

#to run this: sbatch ATACjob.sh (or whatever file name)
#to check: squeue -u pdgardne
#to see if you had errors: less the slurm output files you get. Especially suspicious if alignments run quickly
