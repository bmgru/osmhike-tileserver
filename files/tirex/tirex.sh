
############################################################################################
# startup script for tirex container
#
# this script is executed from /osmhike 
############################################################################################

TIREX=tirex

# project.mml directory
STYLE=style

# database name
DB_OSM=osm

# since this script is run by root, and not by user=1000 , forces created files/dir to be rw
umask 0000

# avoid troubles with wget progress bar
export DEBIAN_FRONTEND=""

# make log files easy to access
chmod a+rX /var/log/apache2
chmod a+rX /var/log/tirex
# manage Tirex cache
mkdir -p /var/cache/tirex/tiles/osmhike
chmod -R a+rwx /var/cache/tirex
# tmp local subdirectory
TMPDIR=tmp
mkdir -p $TMPDIR
DATADIR=$STYLE/data
mkdir -p $DATADIR

# link to leaflet
LEAFLET=$TIREX/html/leaflet
[ -L $LEAFLET ] || ln -s /usr/share/javascript/leaflet $LEAFLET

 
#############################################################
# function to create the needed views
# must be called before running Kosmtik or Tirex, in case some features have been modified
#
############################################################
CreateViewsFunctions()
{

  echo "\nRun cyclosm-specific sql script to create some views"
  psql --dbname=$DB_OSM --file=$STYLE/views.sql

  # create specific sql file for road sizes
  bash scripts/zfact.sh $STYLE $DB_OSM

}



######################### just exec bash ######################
if [ "$1" = "bash" ]
then
  bash
  exit
fi

######################### just compile project.mml ######################
if [ "$1" = "xml" ]
then
  echo "generate XML"
  pwd
  carto $STYLE/project.mml > $STYLE/project.xml
  exit
fi

######################### standard operation  ######################

# create Views/Functions
CreateViewsFunctions

echo ""
echo "=============== generate XML ==============="
echo ""
echo "NOTE: a LOT of warnings will be emitted ... Most of them are false positive"
echo ""

# convert mml to xml
carto $STYLE/project.mml > tmp/project.tmp.xml

# process layers whose datasource is a http url to a .zip shapefile
# CAUTION !!! project.xml MUST be in same directory than project.mml , because it depends on some subdirectories : symbols ...
# use -u flag for python to force it to immediately flush output
# it is IMPORTANT to provide a full path for datadir, because tirex works in another directory 
echo ""
python3 -u $TIREX/xml-patch.py $TMPDIR/project.tmp.xml $STYLE/project.xml   /osmhike/$DATADIR

echo "=============================================="

echo ""
echo "============= start Tirex daemons ============"
# it is difficult to launch Tirex processes with specific user . This is done with runuser + tirex-start.sh
rm -f /var/log/tirex/*
chmod a+rwx /var/log/tirex/

runuser -u _tirex sh $TIREX/tirex-start.sh 
echo ""
echo "================================================="

# this can be used to provide easy visibility to apache/tirex config files
SPY=yes
if [ "$SPY" = "yes" ]
then
  SPYDIR=$TIREX/zzzspy
  rm -rf $SPYDIR
  mkdir -p $SPYDIR
  cp -r /etc/apache2 $SPYDIR
  cp -r /etc/tirex $SPYDIR
fi

if [ "$1" = "server" ]
then
  rm -f /var/log/apache2/*
  echo ""
  echo "============== Running apache in foreground ======================"
  apachectl -DFOREGROUND
else
  echo ""
  echo "============== Running apache in background ======================"
  apachectl start
  echo ""
  echo "============== Running bash ======================"
  bash
fi





