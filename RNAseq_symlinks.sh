#this shell script is what you run AFTER you create rename.RNAseq.py, since it calls that
#file at the end 
find /data/class/ecoevo283/public/RAWDATA/RNAseq/RNAseq384plex_flowcell01/ -name "*.fastq.gz" >fastqs.txt
cat /data/class/ecoevo283/public/RAWDATA/RNAseq/RNAseq384_SampleCoding.txt | cut -f1,12 | tail -n +2 >dict.txt
python rename.RNAseq.py <fastqs.txt