#########################################################
#
# Builds the list of the HGT files needed to cover the area defined by a polygon file
#
# arg1: the poygon file
# arg2: the directory containing HGT files
#
# the output file is a .txt file in the current directory
#########################################################

import sys
import re
import os
import math


def lon2txt(lon):
    if lon >= 0 :
        return "E%03d" % lon
    else:
        return "W%03d" % -lon

def lat2txt(lat):
    if lat >= 0 :
        return "N%02d" % lat
    else:
        return "S%02d" % -lat

latlist={}

filepoly=sys.argv[1]
hgtdir=sys.argv[2]

mem=False
f=open(filepoly,"r")
for line in f :

    if line[0] != " ":
        continue
    line=line.strip()
    line=re.sub(" +",";",line)
    #print("\nline=",line,"END")
    lon,lat=line.split(";")
    #print("lon=",lon," lat ",lat)
    lonf=float(lon)
    latf=float(lat)

    if mem==False:
        memlonf=lonf
        memlatf=latf

    nb=30
    inclon=(lonf - memlonf)/nb
    inclat=(latf - memlatf)/nb
    for i in range(nb):
        lon=math.trunc( memlonf+inclon*i)
        lat=math.trunc( memlatf+inclat*i)

        #print("lon=",lon," lat=",lat)

        if (lon<0): lon=lon-1
        if (lat<0): lat=lat-1

        key=lat2txt(lat)
        if key in latlist:
            zmin,zmax=latlist[key]
            latlist[key] = [ min(zmin,lon) , max(zmax,lon) ]
        else:
            latlist[key] = [lon,lon]

    mem=True
    memlonf=lonf
    memlatf=latf

f.close()

filelist=os.path.basename(filepoly) + ".txt"
latlist=dict( sorted( latlist.items() ) )

f=open(filelist,"w")
for lat,lonrange in latlist.items():
    for lon in range( lonrange[0], lonrange[1]+1 ):
        filename= f'{hgtdir}/{lat}{lon2txt(lon)}.hgt' 
        if os.path.exists(filename):
            f.write(filename + "\n") 
        else:
            print( filename + "=not found")
f.close()
print("filelist=",filelist)


    

