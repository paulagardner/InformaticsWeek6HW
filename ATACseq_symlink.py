####### example sample: Sample_ACCAGCA-TATGCAGT_4R009_L1_P059_R2.fq.gz
#again, taken from Dr. Long's files

#again, run in the directory above the ATACseq/rawdata directories you must have
import os
import re
files=os.listdir("/data/class/ecoevo283/public/RAWDATA/ATACseq")
for f in files:
        if f.endswith('.fq.gz'):
                f2=re.search("P[0-9]+_R[0-9]",f).group(0).replace("R","").replace("_1","_F").replace("_2","_R")
                os.symlink("/data/class/ecoevo283/public/RAWDATA/ATACseq/"+f, "ATACseq/rawdata/" + f2 + ".fq.gz")