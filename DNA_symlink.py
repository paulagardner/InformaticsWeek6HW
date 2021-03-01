#Must run this in the directory above your empty DNAseq directory, which should contain
#an empty rawdata directory- mirroring the structure of the data on the public directory

import os
files=os.listdir("/data/class/ecoevo283/public/RAWDATA/DNAseq")
for f in files:
        if f.endswith('.fq.gz'):
                os.symlink("/data/class/ecoevo283/public/RAWDATA/DNAseq/"+f, "DNAseq/rawdata/"+f) 