#RUN THIS IN the directory above the RNAseq directory. Not sure why it doesn't work
#one level down

#contents of rename.RNAseq.py

#create a table that will allow for sample name lookups..

import os
import re
import sys

###read in tab delimited sample# \t samplename 
#make a dictionary, read in the file "dict.txt" and for each line in the file, split the line and call the first item, the key, to create the dictionary 'value', so that if you type d it will tell you the value

d = {}
with open("dict.txt") as FILEIN:
        for line in FILEIN:
                (key, val) = line.split()
                d[int(key)] = val

###make symlinks
for f in sys.stdin: #f will take on the first value for the path for each sample
        f = f.strip('\n') #strip the line return we don't want
        if f.endswith('.fastq.gz') and "Undetermined" not in f:
                num=re.search("[0-9]+_",f).group(0).replace("_","")
                dir=re.search("_R[0-9]_",f).group(0).replace("_R1_","F").replace("_R2_","R")
                out="RNAseq/rawdata/"+ d[int(num)] + "_" + dir +".fq.gz" #this looks up the value of the value from the table
                print(f,num,dir,out) #print everything out to the screen to debug 
                os.symlink(f, out)