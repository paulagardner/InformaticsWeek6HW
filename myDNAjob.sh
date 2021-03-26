#!/bin/bash 
#SBATCH --job-name=DNA     ## Name of job
#SBATCH -A ecoevo283       ## account to charge
#SBATCH -p standard        ## partition/queue name
#SBATCH --array=1-12       ## number of tasts to launch (prefixes has 12 lines so 12)
#SBATCH --cpus-per-task=2  ## number of cores needed 

#don't forget to do 
# srun -A ecoevo283 --pty bash -i for the class account
module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load java/1.8.0
module load picard-tools/1.87

inpath="/data/class/ecoevo283/pdgardne/DNAseq/" #element from Liz:
#I would spell out the full path for your reference file, like ref="/data/class/ecoevo283/username/ref/dmel-all-chromosome-r6.13.fasta"
#for organization, I like having a path variable in the beginning of the script where all the data inputs/outputs are/will go, so that my bash scripts can live in a scripts directory somewhere else
#inpath="/data/class/ecoevo283/erebboah/DNAseq/"

# or pass the file name to the shell script, how would I do this?
file=$inpath"DNAprefixes.txt"
# is the file indexed for bwa?
ref="/data/class/ecoevo283/pdgardne/ref/dmel-all-chromosome-r6.13.fasta" #alteration by Liz. Not sure why you don't do $inpath here; but removing it fixed it for me
# here is a hint if you had a tab delimited input file
prefix=`head -n $SLURM_ARRAY_TASK_ID  $file | tail -n 1`
samplename=`echo $prefix | sed -e "s/rawdata/bam/"`
idname=`echo $prefix | cut -d "/" -f 3 | cut -d "_" -f 1`


# alignments
bwa mem -t 2 -M $ref ${prefix}_1.fq.gz ${prefix}_2.fq.gz | samtools view -bS - > $samplename.bam
samtools sort $samplename.bam -o $samplename.sort.bam
# GATK likes readgroups
java -jar  /opt/apps/picard-tools/1.87/AddOrReplaceReadGroups.jar I=$samplename.sort.bam O=$samplename.RG.bam SORT_ORDER=coordinate RGPL=illumina RGPU=D109LACXX RGLB=Lib1 RGID=$idname RGSM=$idname VALIDATION_STRINGENCY=LENIENT
samtools index $samplename.RG.bam

#to run this: sbatch myDNAjob.sh (or whatever file name)
#to check: squeue -u pdgardne
#to see if you had errors: less the slurm output files you get. Especially suspicious if alignments run quickly
