#Code w/ lots of assistance from lauren:

#############NOT SURE WHY I CAN'T GET THIS TO RUN AS A .SH... only putting it in line by line
#or so from the command line works
#oh maybe it's because you can't use hashes to delineate notes in this format??? whoops

#####################################
### NEED TO INDEX REF GENOME FIRST ##
#####################################

# In week 5, we organized the data in a non-destructive way 
# by (in an automated fasion) symlinking some files, and making 
# symlinks that were automatically renamed with a python script.
# now, we want to do something with the sequence data- align them
# to reference genomes-- in this case, trusty old dmel-r6.36.fa.gz,
# etc. 

# First we need to run some things on the command line to get everything started:

# We want to run the following in the directory above the ref dir, which
# comes from last week. Ref contains the reference genome in various files
# formats (I think?)

# grab a non-head node
srun -A ecoevo283 --pty bash -i

# you'll also want to check that you have both the dmel fasta and gtf files in a ref driretory 

# Load modules we may need: 
module load bwa/0.7.8
module load samtools/1.10
module load bcftools/1.10.2
module load python/3.8.0
module load gatk/4.1.9.0
module load picard-tools/1.87
module load java/1.8.0
module load hisat2/2.2.1

#create a variable, ref, that is a path to the ref directory and the dmel 
#fasta contained within:
ref="ref/dmel-all-chromosome-r6.13.fasta"

#the link below describes how this code will make a SAM file from this file, 
#which is needed to do the alignment (not sure of the specifics, now)
# https://informatics.fas.harvard.edu/short-introduction-to-bwa.html 
bwa index $ref
samtools faidx $ref

# need to replace .fasta.dict (auto-output) wuth just .dict to make the programs play nice
java -jar /opt/apps/picard-tools/1.87/CreateSequenceDictionary.jar R=$ref O=ref/dmel-all-chromosome-r6.13.dict
# (we had some problems with an error above; we were specifying the wrong path). Also, we weren't sure
# if picardtools was working or not; or where to find it--
# if trying to find picard-tools 
module show picard-tools

#makes alignment program to ref possible 
hisat2-build $ref $ref # $ref $ref = input and output 

#we want to make directories for where our alignment files are going to go:
#make the relevant directories for bam files where alignments will be output 
mkdir DNAseq/bam
mkdir RNAseq/bam
mkdir ATACseq/bam

##################################
### gDNA to Start ################
##################################

#running this also in the directory above our DNAseq, rnaseq, etc- not sure that's right
## prefixes.txt needs to be in same DIR as myDNAjob.sh and the DIR where you RUN that with sbatch 

## now do some command line stuff to make a file of "prefixes" you can step through to do the alignment
## do each one in the relevant directory


# this line lists all files ending in _1.fq.gz in DNA/rawdata and filter/edits them (sed)
# 's/regexp/replacement/' - replaces _1.fq.gz with nothing i.e. leaving only the prefixes in a new text file   
ls rawdata/*_1.fq.gz | sed 's/_1.fq.gz//' >DNAprefixes.txt
#run the above in the DNAseq directory


#In the ATACseq directory:
ls rawdata/*_F.fq.gz | sed 's/_F.fq.gz//' >ATACprefixes.txt

#in the RNAseq directory
#ls rawdata/*_F.fq.gz | sed 's/_F.fq.gz//' >RNAprefixes.txt
ls ~/EE283_files/pdgardne/RNAseq/rawdata/*R.fq.gz | sed 's/_R1.fq.gz//' > RNAprefixes.txt #had to change this from the original as I named my RNA symlinks F and R, not R1 and R2. 
#Affects the RNAseq.sh file as well.



#Now, make sure the fiqles match in the DNA seq prefix 
# make sure file is in unix format 
dos2unix myDNAjob.sh

#submit job-- don't forget, if you haven't in your current session, srun -A ecoevo283 --pty bash -i 
sbatch myDNAjob.sh

#check that it's running-- it takes forever
squeue -u pdgardne
#####DON'T MOVE 

