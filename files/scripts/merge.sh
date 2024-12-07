###############################################################################
# Merge several osm.pbf files  (located in "myfiles" directory 
#
# bash merge.sh  output.osm.pbf  input1.osm.pbf input2.osm.pbf .... 
#
#################################################################################


MYDIR="`dirname $0`"
cd $MYDIR

FILEDIR=../myfiles
OUTPUT="$FILEDIR/$1"
#echo "script=$0 MYDIR=$MYDIR output=$OUTPUT"

shift

all=""
for file in $* 

do
  pbf="$FILEDIR/$file"
  o5m="$pbf.o5m"

  # convert to .o5m , because merge works only with this format
  cmd="osmconvert $pbf -o=$o5m"
  echo $cmd
  $cmd
  all="$all $o5m"
done

# merge .o5m files
cmd="osmconvert $all -o=$OUTPUT"
echo $cmd
$cmd

# final purge
rm -f $all



