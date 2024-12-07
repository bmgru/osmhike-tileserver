##################################################################################################
#
# process layer when datasource is a http url to a .zip shapefile
#
# - download the url using wget
# - make a new version of the xml file ( xmlfile.new.xml ) where datasource is modified to  datadir/layername/layername
# - unzip the file inside tmpdir directory, then rename files , moving somedir/somename.suffix to datadir/layername/layername.suffix
# - delete tmpdir
#
#  python3 xml-patch.py   infile.xml  outfile.xml datadir
##################################################################################################
import sys
import xml.etree.ElementTree as ET
import http.client
import os
import zipfile
import pathlib
import shutil
import urllib

# create a directory, without failing if it already exists
def zmkdir(dirname):
    if (not os.path.isdir(dirname)) : os.mkdir(dirname)

#----------------------------------------------------------
# special unzip 
# the zip file generally contains a subdirectory, and the filenames are similar to this directory, but not always exactly
# unzip the file inside tmpdir directory, then rename files , moving somedir/somename.suffix to datadir/layername/layername.suffix
#-----------------------------------------------------------
def zipextract(filezip,targetdir,layername):

    if (not os.path.isfile(filezip)) : return

    try:
        with zipfile.ZipFile(filezip) as fzip:

            tmpdir="tmpdir"
            zmkdir(tmpdir)
            zmkdir(targetdir)

            for elem in fzip.namelist():
                suffix=pathlib.Path(elem).suffix
                newfile=f'{targetdir}/{layername}{suffix}'
                print("extracting:",elem, " ==> ", newfile)
                fzip.extract(elem,tmpdir)
                os.rename( f'{tmpdir}/{elem}' , newfile)

            shutil.rmtree(tmpdir)

    except zipfile.BadZipFile as error:
        print(error)

#-------------------------------- main -------------------------------------
infile=sys.argv[1]
outfile=sys.argv[2]
datadir=sys.argv[3]

# list of elements to process:  files[url]=layername
files={}  

# analyse xml : find Layer nodes where Datasource is a http url
# store url,name to dictionnary 'files'
tree = ET.parse(infile)
root = tree.getroot()

for child in root:
    #print (child.tag)
    if child.tag == "Layer":
        name=child.attrib["name"]
        for subchild in child:
            if subchild.tag == "Datasource":
                for param in subchild:
                    txt=param.text
                    #print("   ",param.text)
                    if type(txt)== str :
                        if txt.find("http://") != -1 or txt.find("https://") != -1 :
                            param.text = f'{datadir}/{name}/{name}'
                            files[txt]=name

# make a modified copy of the input xml
tree.write(outfile,encoding='unicode',xml_declaration=True)

# process each url
for url,name in files.items() :
    urlparts=urllib.parse.urlparse(url)
    base=os.path.basename(urlparts.path)

    layerdir=f'{datadir}/{name}'    
    zipfilename=f'{layerdir}/{base}'
    zmkdir(layerdir)
    print("-----------------------------------------------------------------------")
    print( f'Layer: {name}  Process url {url}')
    if (not os.path.isfile(zipfilename)) : 
        cmd= f'wget --no-check-certificate --no-verbose {url} -O {zipfilename}'
        print(cmd)
        os.system(cmd)
        zipextract(zipfilename,layerdir,name)
    else:
        print( f'{zipfilename} already exists: nothing to do')
    print("-----------------------------------------------------------------------\n")

