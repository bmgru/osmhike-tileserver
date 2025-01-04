#############################################################################################
#
#
#
#############################################################################################

import sys
import re
import os
import math
import csv
import json

csvfile=sys.argv[1]

# funcs[funcname][key]=row
funcs={}

# indentation
b1="  "
b2="    "
b3="      "
b4="        "
b5="          "

#----------------------------------------------------------
# make zzoom function
#----------------------------------------------------------
def header():
    txt="""
-- Generated Code: do not modify this file

-- transforms scale_denominator to zoom value
DROP FUNCTION IF EXISTS zzoom;
CREATE OR REPLACE FUNCTION zzoom( scale numeric)    
  returns integer language plpgsql as $$
BEGIN
  RETURN ROUND(   log( 2 , 559082264 / scale )     );
END
$$;

-- allows to trace
DROP FUNCTION IF EXISTS ztrace;
CREATE OR REPLACE FUNCTION ztrace( msg text, txt text )    
  returns text language plpgsql as $$
BEGIN
  RAISE INFO 'ZTRACE %  value=%', msg , txt ;
  RETURN txt;
END
$$;
"""
    print(txt)

#----------------------------------------------------------
# zoom / scale conversion 
#
# scale = 559082264 / 2**zoom
#----------------------------------------------------------
"""
0 559082264.0
1 279541132.0
2 139770566.0
3 69885283.0
4 34942641.5
5 17471320.75
6 8735660.375
7 4367830.1875
8 2183915.09375
9 1091957.546875
10 545978.7734375
11 272989.38671875
12 136494.693359375
13 68247.3466796875
14 34123.67333984375
15 17061.836669921875
16 8530.918334960938
17 4265.459167480469
18 2132.7295837402344
19 1066.3647918701172
20 533.1823959350586
"""
# to transform  (WHEN zoom >= zoomlimit)  into  (WHEN scale < scalelimit)
# we take a scale value immediately superior to the value corresponding exactly to the zoom
zoom2scale={
"0"  : 750000000,
"1"  : 400000000,
"2"  : 200000000,
"3"  : 125000000,
"4"  : 50000000,
"5"  : 25000000,
"6"  : 10000000,
"7"  : 7500000,
"8"  : 3000000,
"9"  : 1500000,
"10" : 750000,
"11" : 400000,
"12" : 200000,
"13" : 100000,
"14" : 50000,
"15" : 25000,
"16" : 12500,
"17" : 6000,
"18" : 3000,
"19" : 1500,
"20" : 750
}




#-----------------------------------------------------------
# render name/blank separated list of names
#   "toto"  => = 'toto'
#   "toto   titi"  => IN ( 'toto', 'titi')
#-----------------------------------------------------------
def RenderCondition( names ):
    Q="'"
    names =names.strip();
    names= names.replace("\n"," ")
    names= names.replace("\r"," ")
    tabnames=names.split(" ")
    ttt=[]
    for name in tabnames:
        if name != "" : ttt.append( Q + name + Q )
    if len(ttt) == 1:
        return " = %s " % ttt[0]
    else:
        return " IN ( " + ",".join(ttt) + ")"

#-----------------------------------------------------------
# returns the block for zoom value
#-----------------------------------------------------------
def zoomblock( values,indent ):
    txt=[]
    txt.append(indent+"CASE")
    kkk=list( values.keys() )
    kkk.reverse()

    for k in kkk:
        v=values[k]
        v=v.replace("," , ".")
        
        if k.isdigit() and v!= "":
            #print("TRACE ",k,"value",v)
            #print("WHEN zoom >= %s THEN %s" % (k,v ) )
            txt.append( indent + b1 + "WHEN scale < %d THEN  r = %s::numeric ; --zoom >= %s " % ( zoom2scale[k] ,v, k) )
    txt.append( indent + b1 + "WHEN false THEN r = 0::numeric ;")   # if no values, this makes sure there is at least one WHEN, to avoid sql error
    txt.append( indent + b1 + "ELSE r = 0::numeric ;") 
    txt.append( indent + "END CASE;") 
    return txt

#-----------------------------------------------------------
# Returns the text of a function
#-----------------------------------------------------------
def CreateFunction( name  ):
    funcname="zfact_%s" %name
    txt=[""]

    txt.append("-- Generated Code: do not modify it")
    txt.append("DROP FUNCTION IF EXISTS %s ;" % funcname)
    txt.append("""CREATE OR REPLACE FUNCTION %s( key text, scale numeric)    
                returns numeric language plpgsql as $$""" % funcname)
    txt.append("""
DECLARE
  zoom integer;
  r    numeric;
BEGIN
  -- zoom = ROUND(   log( 2 , 559082264 / scale )     );

""" )
  
    txt.append(b1+"CASE")
    txt.append( b2+ "WHEN False THEN r = 0::numeric ;" )  # avoid trouble, if there is only "*" as key value
    for k,values in funcs[name].items():
        if k != "*":
            txt.append( b2+ "WHEN key %s THEN" % RenderCondition(k)  )
            txt=txt+ zoomblock(values,b3)

    # the ELSE condition
    if "*" in funcs[name]:
        values=funcs[name]["*"]
        txt.append( b2+"ELSE")
        txt=txt+ zoomblock(values,b3)
    else:
        txt.append(b3 + "ELSE r = 0::numeric ;")  # ELSE and RETURN must be on same line, otherwise error 

    txt.append(b1+"END CASE;")
    txt.append(b1+"RETURN r;")
    txt.append("END")
    txt.append("$$;")
    print( "\n".join(txt))

#-------------------- main ---------------------------------------------

# check the first line to see what is the csv separator
with open(csvfile) as f:
    txt=f.readline()
    if txt.find(";") >=0:
        SEP=";"
    else:
        SEP=","

# read csv file and build  funcs
with open(csvfile) as f:
    reader = csv.DictReader(f,delimiter=SEP)
    for row in reader:
        # skip some rows
        if row["skip"] != "" : continue

        # clean and skip blanks
        funcname=row["function"]
        funcname=funcname.strip()
        if funcname == "" : continue
        key=row["key"]
        key=key.strip()
        if key == "" : continue
        
        if funcname not in funcs:
            funcs[funcname]={}
        funcs[funcname][key]=row

#print ( json.dumps(funcs, indent=4))
#----------------- print the sql definitions to output --------------------
header()
for name,data in funcs.items():
    CreateFunction(name)

