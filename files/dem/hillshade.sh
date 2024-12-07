#####################################################
#
# build hillshade 
#
# bash ../dem/hillshade.sh listfile.txt resolution zfactor
#
#####################################################

INFILE=$1
RESOLUTION=$2
ZFACTOR=$3


WARPFILE=warp-$RESOLUTION.tif
HILLFILE=hillshade-$RESOLUTION.tif

rm -f $WARPFILE
rm -f $HILLFILE

echo ""
echo "************ Merging files with gdalwarp *****************"
# -co COMPRESS=LZW
# -t_srs "+proj=merc +ellps=sphere +R=6378137 +a=6378137 +units=m"


  cmd="gdalwarp  -co BIGTIFF=YES -co TILED=YES  -co PREDICTOR=2 -co COMPRESS=DEFLATE -t_srs  EPSG:3857 -r bilinear -rcs -order 3 -tr $RESOLUTION $RESOLUTION  -wo SAMPLE_STEPS=100 --optfile $INFILE  $WARPFILE"
  echo $cmd
  $cmd


  echo ""
  echo "************ creating hillshade with gdaldem *****************"
# -co COMPRESS=JPEG  causes many strange square pixels

  cmd="gdaldem hillshade -z $ZFACTOR -compute_edges  -co PREDICTOR=2 -co COMPRESS=DEFLATE $WARPFILE $HILLFILE"
  echo $cmd
  $cmd


