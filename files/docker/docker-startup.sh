#!/bin/sh

############################################################################################
# this script is executed from /osmhike 
############################################################################################

# databases names 
DB_OSM=osm
DB_CONTOURS=contours


# working directory for contours
mkdir -p demdata

# style directory
STYLE=style

# data directory used by Kosmtik to download shapefiles
mkdir -p $STYLE/data
chmod a+rwX $STYLE/data


#------------------- Testing if database is ready -----------------------
i=1
MAXCOUNT=60

echo "Waiting for PostgreSQL to be running"
while [ $i -le $MAXCOUNT ]
do
  pg_isready -q && echo "PostgreSQL running" && break
  sleep 2
  i=$((i+1))
done
test $i -gt $MAXCOUNT && echo "Timeout while waiting for PostgreSQL to be running"


ACTION=$1
PARAM=$2

#############################################################
# function to create a database
#  $1: database name
#  $2,$3: if not empty, name of an extension to install
############################################################
CreateDatabase()
{
  psql -c "SELECT 1 FROM pg_database WHERE datname = '$1';" | grep -q 1 || createdb $1
  if [ "$2" != "" ]
  then
    psql -d $1 -c "CREATE EXTENSION IF NOT EXISTS $2;"
  fi
  if [ "$3" != "" ]
  then
    psql -d $1 -c "CREATE EXTENSION IF NOT EXISTS $3;"
  fi
}

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



echo "\n===================ACTION=$ACTION====== `date '+%H:%M:%S'` ==================================="



case $ACTION in

#################### import OSM file to database #####################
import)

  echo "\n==================== working with AREA=$AREAOSM ================"

  echo "\n Creating default database + extensions"
  #psql -c "SELECT 1 FROM pg_database WHERE datname = '$DB_OSM';" | grep -q 1 || createdb $DB_OSM && \
  #psql -d $DB_OSM -c 'CREATE EXTENSION IF NOT EXISTS postgis;' && \
  #psql -d $DB_OSM -c 'CREATE EXTENSION IF NOT EXISTS hstore;' && \
  CreateDatabase $DB_OSM postgis hstore

  # if AREAOSM does not contain a directory, append "myfiles"
  if [ "`dirname $AREAOSM`" = "." ]
  then
     OSMFILE="./myfiles/$AREAOSM"
  else
     OSMFILE=$AREAOSM
  fi

  echo "\n  Importing data to  database, using osm2pgsql"
  osm2pgsql \
  --cache $OSM2PGSQL_CACHE \
  --number-processes $OSM2PGSQL_NUMPROC \
  --hstore \
  --database $DB_OSM \
  --slim \
  -c \
  -G \
  --drop  \
 $OSMFILE



  echo "\nCreate indexes to optimize performance `date '+%H:%M:%S'` "
  psql --dbname=$DB_OSM --file=$STYLE/zindex.sql

  # creation of Views/Functions
  CreateViewsFunctions



  echo ""
  echo "Finished !   `date '+%H:%M:%S'` " 
  #echo "Finished !  This container will sleep for a long time, doing nothing . You can stop it without damage with CTRL/C"
  #echo "You can inspect its contents and database, by typing in another shell window:"
  #echo "    docker exec -it c-import  bash"
  #sleep 10000

  ;;


######################## create the database containing contours ############
contours | contours2)

  # CAUTION : before calling this:
  #           * a polygon file $AREAPOLY.poly   is to be downloaded from geobabrik  ( typically  wget http://download.geofabrik.de/europe/andorra.poly )
  #             it contains a list of lon/lat coordinates that define the perimeter for which we build contours

  # go to specific directory
  cd demdata 


  # ACTION=contours2 allows to execute only step2 if we just need to recreate database  ( step1  is quite long )
  if [ "$ACTION" != "contours2" ]
  then

    # STEP1 : download elevation files, and produce .osm.pbf contour file using pyhgtmap

    # run phyghtmap to download elevation files ( .hgt )  corresponding to $CONTOURS.poly
    # we use --source=view1 by default ,to download freely from  www.viewfinderpanoramas.org , rather than NASA which needs a very complex registration
    #  -s 10 produces contour lines with 10 meters interval
    #  output file will be AREAPOLY_lon_xxxx_lat_yyy.osm.pbf
    POLYGON=../myfiles/$AREAPOLY
    echo ""
    echo "***************** CONTOURS STEP1: run phyghtmap on file=$POLYGON  source=$AREAPOLYSOURCE  `date '+%H:%M:%S'` ********************"

    rm -f $AREAPOLY*.osm.pbf
    bash ../dem/pyhgtmap.sh  --polygon=$POLYGON -j 8 -s 10 -0 --source=$AREAPOLYSOURCE  --max-nodes-per-tile=0 --max-nodes-per-way=0 --pbf -o $AREAPOLY
  fi

  # STEP2 : create another database "contours"  and store contour lines , using osm2pgsql
  # in this database, contour lines will be in table "planet_osm_line" , using column "ele" to store height value
  echo "\n**************** CONTOURS STEP2: use osm2pgsql to import data  `date '+%H:%M:%S'` *******************\n"

  CreateDatabase $DB_CONTOURS postgis
  #psql -c "SELECT 1 FROM pg_database WHERE datname = '$DB_CONTOURS';" | grep -q 1 || createdb $DB_CONTOURS
  #psql -d $DB_CONTOURS -c 'CREATE EXTENSION IF NOT EXISTS postgis;'

  osm2pgsql --slim --drop -d $DB_CONTOURS    --cache $OSM2PGSQL_CACHE --style ../dem/contours.style ./$AREAPOLY*.osm.pbf



  echo "\n------------------------- Create indexes to optimize performance `date '+%H:%M:%S'` --------------------"
  psql --dbname=$DB_CONTOURS --file=../dem/zindexcontours.sql

  echo "\n--------------------Table and Index sizes --------------------\n"
  psql --dbname=$DB_CONTOURS -c "\dt+"
  psql --dbname=$DB_CONTOURS -c "\di+"

  echo ""
  echo "Finished !  Contours have been generated `date '+%H:%M:%S'` "

  ;;

############################ generate file containing hillshade ##########################
hillshade)

  cd demdata

  # the place where hgt files have been stored, depends on the source
  HGTDIR=hgt/VIEW1
  if [ "$AREAPOLYSOURCE" =  "view3" ]
  then
    HGTDIR=hgt/VIEW3
  fi
  

  echo ""
  echo "************** Build the list of needed .hgt files from $HGTDIR`date '+%H:%M:%S'` ****************"

  python3 ../dem/hgtlist.py ../myfiles/$AREAPOLY $HGTDIR 

  # process needed file for required resolution
  # this action can be repeated with different resolutions

  echo "\n######################## compute hillshade RESOLUTION=500 ###########################\n"
  sh ../dem/hillshade.sh $AREAPOLY.txt 500 10   # low resolution

  echo "\n######################## compute hillshade RESOLUTION=30 ###########################\n"
  sh ../dem/hillshade.sh $AREAPOLY.txt 30  3    # high resolution

  echo "\nFinished !  Hillshade have been generated `date '+%H:%M:%S'` "
  ;;


####################### Create the Legend : part1 ###############################
legend1)

      echo "\n==================== create the Legend osm file and import it to database  ==========="

      echo "\n------------ Creating  database with extensions ---------------"
      CreateDatabase $DB_OSM postgis hstore
      #psql -c "SELECT 1 FROM pg_database WHERE datname = '$DB_OSM';" | grep -q 1 || createdb $DB_OSM && \
      #psql -d $DB_OSM -c 'CREATE EXTENSION IF NOT EXISTS postgis;' && \
      #psql -d $DB_OSM -c 'CREATE EXTENSION IF NOT EXISTS hstore;' && \

      OSMLEGEND="legend/legend.osm"
      echo "\n------------ Create legend osm file : $OSMLEGEND ---------------"

      python3 legend/makelegend.py osm
      

      echo "\n------------ Import legend file to database  ---------------"
      osm2pgsql --hstore --slim -c -G --drop --database $DB_OSM  $OSMLEGEND

      # creation of Views/Functions
      CreateViewsFunctions

      echo "\n------------ finished !  ---------------"
      ;;

####################### Create the Legend : part2 ###############################
legend2)


      echo "\n==================== Create the Legend jpg file   ==========="

      python3 legend/makelegend.py jpg


   echo "\n------------ finished !  ---------------"
   ;;

############################ Kosmtik rendering server ##################
kosmtik)

  # Starting Kosmtik

  # Creating default Kosmtik settings file
  if [ ! -e ".kosmtik-config.yml" ]; then
    cp /tmp/.kosmtik-config.yml .kosmtik-config.yml  
  fi
  export KOSMTIK_CONFIGPATH=".kosmtik-config.yml"

  # creation of views/Functions
  CreateViewsFunctions


  # tile web server
  kosmtik serve $STYLE/project.mml --host 0.0.0.0
  # It needs Ctrl+C to be interrupted


;;

############################ Kosmtik : just produce mapnik  .xml file ##################
xml)


  echo "----------- Kosmtik: produce project.xml file ---------------"
  #kosmtik -h
  kosmtik export $STYLE/project.mml --output $STYLE/project.xml


;;


################### any other values is command+parameters to execute
*)
  $*
  ;;


esac
