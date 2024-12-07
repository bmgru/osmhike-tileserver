######################################################################################
# Entrypoint for direct execution of pyhgtmap/phyghtmap, without having to install the packages 
#
#  pyhgtmap:  ( new version to use with ubuntu:noble )
#    pip package downloaded using:   pip download -d /tmp --no-deps pyhgtmap 
#
#  phyghtmap:  ( old version that works until ubuntu:focal )
#    download latest source distribution  from  http://katze.tfiu.de/projects/phyghtmap/ 
#
#  This uses a tricky hint with PYTHONPATH , just to have  "from phyghtmap import hgt"  working properly 
#####################################################################################


DIR=`dirname $0`


if [ "$USEPHYGHTMAP" = "yes" ]
then

    #--------------- old phyghtmap ( direct execution of python code )----------------
    #export PYTHONPATH=$DIR/phyghtmap
    #python3 $DIR/phyghtmap/phyghtmap/main.py $*

    #--------------- old phyghtmap ( execution from installed package )----------------
    echo phyghtmap $*
    phyghtmap $*

else


    #--------------- new pyhgtmap ----------------

    # Using $VENV allows to run python from the virtual environment, so that pip installed packages are available
    # it avoids the need of executing    source    /venv/bin/activate  
    VENVPYTHON="/venv/bin/python3"

    MAPOPTIONS="-l INFO"
    export PYTHONPATH=$DIR/pyhgtmap
    $VENVPYTHON $DIR/pyhgtmap/pyhgtmap/main.py $MAPOPTIONS $*

fi
