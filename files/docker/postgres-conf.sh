#!/bin/sh

set -e

# This script is executed ONLY ONCE , when database directory is initialized
# it is stored in directory docker-entrypoint-initdb.d  , so that the startup script automatically runs it
# NOTE:
# the project directory "files/dbconf" is mapped to /dbconf inside the container

CONFFILE=$PGDATA/postgresql.conf
echo "================ tune $CONFFILE=================="



# modify standard configuration file , to include our specific one
if  ! fgrep "myconf.conf" $CONFFILE 
then
    echo "include_if_exists '/dbconf/myconf.conf'" >>$CONFFILE
fi




