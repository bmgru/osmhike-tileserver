
##############################################################
# create specif SQL functions from a .csv definition
#   $1 = directory containing zfact.csv file
#   $2 = database name
#
#   zfact.sql will be produced in same directory
#############################################################

echo ""
echo "------------- Create specific sql functions to $2 ----------------"

DIR=`dirname $0`

csvfile=$1/zfact.csv
sqlfile=$1/zfact.sql
python3 $DIR/zfact.py $csvfile > $sqlfile
chmod a+rw $sqlfile
psql  -d $2 --file=$sqlfile

echo "---------------------------------------------------------------"
echo ""
