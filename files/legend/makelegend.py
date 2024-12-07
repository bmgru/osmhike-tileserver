#########################################################################
# Build the legend
#
#  Step1: build the .osm file describing the fake world
#     python3 makelegend.py  osm
#
#  Step2: once the tile server is operationnal, use it to get tiles, and combine them to legend.jpg
#      python3 makelegend.py jpg
#
# Note: the script sets its  working directory to the one containing this script
#
##########################################################################

import math
import http.client
import sys
from PIL import Image
import os
import glob


# tile server uri used by Kosmtik
# CAUTION : if "style" directory changes, you must recheck this value !
TileServerUri="/style/tile/{Z}/{X}/{Y}.png"

# define the lat/lon sizes of the legend objects
zdelta=0.001
londelta=4*zdelta
latdelta=-2*zdelta
latmiddle=-zdelta
coldelta=4*londelta

# start value for objects id
zid=10000000  

# will be computed to get the borders of the legend
maxlat=0
maxlon=0
minlat=0
minlon=0

# baselat,baselon define the margin of legend objects, relative to legend border
baselat=-zdelta
baselon=zdelta

# current position to draw an object
zlat=baselat
zlon=baselon


# we need to store ALL elements before writing them to output file
# because osm2pgsql requires that ALL <node> elements appear first
nodes=[]
ways=[]

# change working dir to script directory
dir=os.path.dirname(sys.argv[0])
if dir != "" : os.chdir(dir)



####################### update lat/lon max/min values #########
# this is used to draw a border
################################################################
def makeminmax():
  global maxlat,minlat,maxlon,minlon,zlat,zlon
  maxlat=max(maxlat,zlat)
  minlat=min(minlat,zlat)
  maxlon=max(maxlon,zlon)
  minlon=min(minlon,zlon)

######################## transforms a text "x=y,a=b" to a dictionnary #############
def tags2dict(txt):
  dicttag={}
  tags=txt.split(",")
  for tag in tags:
    if "=" in tag :
        k,v=tag.split("=",2)
        dicttag[k]=v

  return dicttag

####################### make a node ######################################
# if label is not empty, it means that this node is just for printing a label
# in this case, add 2 tags :  label,name
##########################################################################
def makepoint(lat,lon,label=""):
  global zid
  global zlat
  global nodes

  nodes.append( f'  <node id="{zid}" lat="{lat}" lon="{lon}" >')

  if label != "":
    nodes.append(f'     <tag k="label" v="{label}" />')
    nodes.append(f'     <tag k="name" v="##LEGEND##" />')
  nodes.append( f'  </node>')
  zid=zid+1


############################ draw a polygon #######################
# An extra point is drawn at (lonlabel,latlabel) to draw the label 
####################################################################
def drawpolygon(lat1,lat2,lon1,lon2,txttags,label,latlabel=0,lonlabel=0):
  global zlat,zlon,zid
 
  #print( "polygon",lon1,lon2,lat1,lat2)
  memid=zid
  makepoint(lat1,lon1)
  makepoint(lat1,lon2)
  makepoint(lat2,lon2)
  makepoint(lat2,lon1)


  ways.append( f'<way id="{zid}">')

  tags=tags2dict( txttags )
  # all the tag will be copied, excepted 'label' which will be put on a dedicated extra point, out of the polygon
  # ( this is done to avoid rules that may print the label inside the polygon)


  makepoint(latlabel,lonlabel,label)
  print( "poly: ",label)
  for k,v in  tags.items():
        ways.append( f'  <tag k="{k}"  v="{v}" />')

  ways.append( f'  <nd ref="{memid}"  />')
  ways.append( f'  <nd ref="{memid+1}"  /> ')
  ways.append( f'  <nd ref="{memid+2}"  /> ')
  ways.append( f'  <nd ref="{memid+3}"  /> ')
  ways.append( f'  <nd ref="{memid}"  /> ')
  zid=zid+1

  ways.append( "</way>")
  ways.append( "")
  zlon = zlon + coldelta
  makeminmax()

######################### make a polygon at current zlat,zlon position ######################
# A label is printed on the right
############################################################################################
def dopolygon(txttags,label):
  drawpolygon(zlat,zlat+latdelta,zlon,zlon+londelta,txttags,  label,zlat+latmiddle,zlon+1.1*londelta)

############################ draw a line at current zlat,zlon position ######################
# A label is printed on the right
############################################################################################
def doline(txttags,label):
  global zlat,zlon,zid

  memid=zid

  makepoint(zlat+latmiddle,zlon)
  makepoint(zlat+latmiddle,zlon+londelta)

  ways.append( f'<way id="{zid}">')

  tags=tags2dict(txttags)
  makepoint(zlat+latmiddle,zlon+londelta,label)
  print( "line: ",label)
  for k,v in  tags.items():
    ways.append( f'  <tag k="{k}"  v="{v}" />')

  ways.append( f'  <nd ref="{memid}"  />')
  ways.append( f'  <nd ref="{memid+1}"  /> ')
  zid=zid+1


  ways.append( "</way>")
  ways.append( "")
  zlon = zlon + coldelta
  makeminmax()

############################## new block : return to left border #############################################
def doblock():
  global baselat,baselon,zlat,zlon
  zlon=baselon
  zlat=zlat+latdelta+0.5*latdelta
  makeminmax()

########################### draw border polygon #############################
def doborder():
  global minlon,maxlon,minlat,maxlat


  zoom=15
  # extend SE edge to match a tile frontier
  x,y = lonlat2xy(maxlon,minlat,zoom)
  if  x != int(x) : x =int(x) +1
  if  y != int(y) : y =int(y) +1
  maxlon,minlat = xy2lonlat( x-0.001 , y - 0.001,zoom)

  # border poygon containing legend . 
  # for some incredible reason, osm2pgsql will NOT convert the <way> element into a polygon, if there is not an attribute like "landuse" or "natural"
  # attributes like "name","boundary" ... do not work
  drawpolygon(maxlat ,minlat,minlon,maxlon,"name=##LEGEND##,landuse=xxx",   "LEGEND" ,maxlat+2*zdelta,(minlon+maxlon)/2)


  # OBSOLETE: extra polygon, jut to hold the LEGEND text . This one has the label
  #drawpolygon(maxlat+3*zdelta,maxlat+zdelta,minlon-zdelta,maxlon+zdelta,["name=##LEGEND##","label=LEGEND","landuse=LEGEND"],   False ,maxlat+2*zdelta,(minlon+maxlon)/2) 

################################ Conversion lon/lat <=> tiles X/Y ################################################

def lonlat2xy( lon_deg, lat_deg, zoom):
  lat_rad = math.radians(lat_deg)
  n = 1 << zoom
  xtile = (lon_deg + 180.0) / 360.0 * n
  ytile = (1.0 - math.asinh(math.tan(lat_rad)) / math.pi) / 2.0 * n
  return xtile, ytile

def lonlat2tile( lon_deg, lat_deg, zoom):
    x,y = lonlat2xy( lon_deg, lat_deg, zoom)
    return int(x) , int(y)

def xy2lonlat(xtile, ytile, zoom):
  n = 1 << zoom
  lon_deg = xtile / n * 360.0 - 180.0
  lat_rad = math.atan(math.sinh(math.pi * (1 - 2 * ytile / n)))
  lat_deg = math.degrees(lat_rad)
  return lon_deg, lat_deg

############################# download tile #################################
def gettile(zoom,x,y):

    # CAUTION ! when called from a container, the kosmtik rendering server is seen as host=kosmtik port=6789
    #conn = http.client.HTTPConnection("localhost",8888)
    conn = http.client.HTTPConnection("kosmtik",6789)

    uri=TileServerUri
    params={ "{Z}": zoom , "{X}": x , "{Y}": y }
    for key,value in params.items() :
        uri=uri.replace( key,str(value)  )
    file="tmp-z%d-%d-%d.png" %(zoom,x,y)

    print(f'Download file={file} from uri={uri}   ')
    conn.request("GET", uri)
    response = conn.getresponse()
    status = response.status
    bytes = response.read()

    print(f'   ==> Download STATUS={status} ')


    f=open(file,"wb")
    f.write(bytes)
    f.close()
    return file


############################ write output ###################################
def writeosm(filename):
    global nodes,ways

    fout=open(filename,"w")

    fout.write("<?xml version='1.0' encoding='UTF-8'?>\n")
    fout.write("<osm version='0.6' generator='osmconvert 0.8.10'>\n")
    #fout.write("<bounds minlat='0' minlon='0' maxlat='10' maxlon='10' />\n")

    for node in nodes:
      fout.write(node + "\n")
    for way in ways:
      fout.write(way + "\n")

    fout.write("</osm>\n")
    fout.close

############################# make legend.png ##########################
def makelegend(filename):
    global minlon,maxlon,minlat,maxlat

    # get tile numbers
    zoom=15
    xmin,ymin= lonlat2tile(minlon,maxlat,zoom)
    xmax,ymax= lonlat2tile(maxlon,minlat,zoom)

    nbx=xmax+1 -xmin
    nby=ymax+1 -ymin

    legend = Image.new('RGB', (256*nbx, 256*nby))

    for x in range(nbx):
        for y in range(nby):
            tmppng=gettile(zoom,xmin+x,ymin+y)
            tilepng=Image.open(tmppng)
            legend.paste(tilepng, (x*256,y*256) )

    legend.save( filename )

    # delete tmp file
    for file in glob.glob("tmp*.png") :
      os.unlink( file )

############################## main #########################################
f=open("legend.txt","r")


for line in f:
  line=line.strip()
  if line == "" :    continue
  if line[0] == "#" :    continue
  line = line + ";;;"  # add extra separators to avoid side effects
  kind,tags,label,xxxx = line.split(";" , 3)

  if kind=="poly" :
    dopolygon(tags,label)
  if kind=="line" :
    doline(tags,label)
  if kind=="block" :
    doblock()

# add an extra empty block
doblock()
# draw the border
doborder() 

f.close() 

if sys.argv[1] == "osm":
    writeosm("legend.osm")
else:
    makelegend("legend.jpg")
