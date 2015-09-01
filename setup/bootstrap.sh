#!/bin/bash

if [ -f ~/.bootstrap_complete ]; then
    exit 0
fi

#sudo mkdir /shared
#sudo mount -t vboxsf gis /shared

sudo echo "deb http://qgis.org/debian jessie main" | sudo tee /etc/apt/sources.list.d/qgis.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 3FF5FFCAD71472C4
sudo aptitude update
sudo aptitude -y upgrade
sudo aptitude -y install lightdm mate-desktop-environment-core pluma iceweasel qgis qgis-server apache2 libapache2-mod-fcgid cgi-mapserver mapserver-bin mapserver-doc postgis
sudo ln -s /usr/lib/cgi-bin/mapserv /usr/lib/cgi-bin/mapserv.fcgi
sudo a2enmod rewrite
sudo sed -i -e 's/mod_cgid.c/mod_fcgid.c/' /etc/apache2/conf-available/serve-cgi-bin.conf
sudo a2enconf serve-cgi-bin
sudo service apache2 restart

sudo sed -i -e 's/us/fr/' /etc/default/keyboard

# create dbuser user and dbuser-db database
sudo su postgres -c "createuser --superuser --createdb dbuser"
sudo -u postgres psql -c "ALTER USER dbuser WITH PASSWORD 'dbuser'"
sudo su postgres -c "createdb dbuser"
sudo su postgres -c "createdb -O dbuser dbuser-db"
export PGPASSWORD='dbuser'
psql -U dbuser -h 127.0.0.1 dbuser-db -c 'create extension postgis'

cd /tmp
mkdir corse
cd corse
wget http://download.geofabrik.de/europe/france/corse-latest.shp.zip
unzip corse-latest.shp.zip
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_landuse landuse.shp
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_natural natural.shp
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_places places.shp
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_points points.shp
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_railways railways.shp
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_waterways waterways.shp
ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln corse_roads roads.shp

#cd /tmp
#mkdir italie
#cd italie
#wget http://download.geofabrik.de/europe/italy-latest.shp.zip
#unzip italy-latest.shp.zip
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_landuse landuse.shp
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_natural natural.shp
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_places places.shp
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_points points.shp
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_railways railways.shp
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_waterways waterways.shp
#ogr2ogr -f PostgreSQL PG:"host=127.0.0.1 port=5432 dbname='dbuser-db' user='dbuser' password='dbuser'" -nln italie_roads roads.shp

sudo rm -rf /var/www/html
sudo ln -s /shared/gis /var/www/html

echo "reboooooooooooooooot !"

# we did it. let's mark the script as complete
touch ~/.bootstrap_complete
