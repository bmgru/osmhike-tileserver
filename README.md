Osmhike
======= 

## Hiking oriented tile server, based on Cyclosm

This is a strongly reworked clone of CyclOSM (cyclosm-cartocss-style-master  on github  sept2024) 

Three goals:
- allow to build a personnal tile-server, for producing maps adapted to mountain hiking, (without loosing too much bike information)
- provide a full beginner's tutorial ( the one I would have liked to have at the beginning of the project )
- implement contours and hillshade

## Requirements

Designed for Linux. 
The Docker infrastructure must be installed ( see mini-guide in tutorial  )

People stuck on Windows, might try the WSL feature of Windows, which allows to run Linux inside Windows...

## Installation

Download the project from github as a .zip file, and unzip to your home directory

Rename it as you want:  (eg:   ~/myproject) , and (IMPORTANT) make all subdirectories accessible to everybody
```
chmod -R a+rX  ~/myproject 
```
IMPORTANT:  Check that your userid is 1000 ( because it is the one used by several docker containers )
<br>If not, make the project tree rw by everybody
```
chmod -R a+rwX  ~/myproject 
```

*Note: it is possible that if you don't create the project inside a home directory, then Docker might have trouble to do volume mappings...*

## Preparation

Notes: 
- all docker commands must be executed from sudo
- this installation contains OSM data for Andorra, to have a small working example

Go to project directory ( where file docker-compose-yml resides )

Build "db" image (the database server)
```
sudo docker-compose build db  
```

Build "import" image ( the osm data import tool )
```
sudo docker-compose build import
```

Build "kosmtik" image ( the tile rendering and web server )
```
sudo docker-compose build kosmtik
```

## Launching the demo based on Andorra data

Launch database
```
sudo docker-compose up -V db
```

Import the data  ( do it from another shell window, because the previous action keeps running in foreground )

Note that after this command, the db container will exit from its terminal . But it continues to work in background
```
sudo docker-compose up -V import
```

Generate contours lines  ( note the usage of RUN command with argument )
<br> It will take many minutes, to download elevation data from Internet 
```
sudo docker-compose run import contours
```

Generate hillshade  ( note the usage of RUN command with argument )
```
sudo docker-compose run import hillshade
```

Launch the tiles web server.  Note: the first time, kosmtik may spend many minutes to download shapefiles from Internet...
```
sudo docker-compose up -V kosmtik
```

Navigate in the map : open a browser on the below url , and move the map until you see Andorra
```
http://localhost:8888
```


To stop kosmtik, just type CTRL/C in its window<br>
To stop the database, use:  sudo docker-compose stop db

Note:
You can ommit "docker-compose up db" 
It will be done silently when launching import or kosmtik
( but the first execution of "db" initializes the database, and  I prefer to see clearly what happens at that moment )

Note:
The -V option inside docker-compose up -V,  forces the container to start from a fresh new filesystem
It is useful when you stop/start the container several times

Note:
After many runs, the Docker system may be overloaded with obsolete stuff  (stopped containers ...)
This commands does some cleaning
```
sudo docker system prune
```
 
## Load data from another area

In file ".env" , modify the variables which define the files to use
( filenames are relative to subdirectory "files/myfiles" )
- AREAOSM : the name of the .osm.pbf  file
- AREAPOLY:  the name of the polygon file that define the area for which the import phase will download "elevation data"

The best place to find such data is 
- https://download.geofabrik.de/
- https://download.geofabrik.de/europe

Then run again import phases ( Caution! it will erase previous database )
```
sudo docker-compose up  -V import
sudo docker-compose run  import contours
sudo docker-compose run  import hillshade
```

## Hints ##

Force Kosmtik to produce the .xml file, used by Mapnik
```
sudo docker-compose run  kosmtik xml
```

Execute psql to navigate into database
```
sudo docker-compose run  import psql
```


