#!/bin/sh
source config.sh

export PATH=$PATH:/opt/local/lib/mysql5/bin 

# Update mysql settings for python
rm settings.py
echo "MYSQL_USER = '$MYSQL_USER'
MYSQL_PASSWORD = '$MYSQL_PASSWORD'
MYSQL_DATABASE = '$MYSQL_DATABASE'
MYSQL_HOST = '$MYSQL_HOST'" > settings.py

mkdir gtfs
rm -Rf gtfs/*
cd gtfs

wget "$GTFS_URL" -O gtfs.zip
unzip gtfs.zip
rm gtfs.zip

cat ../sql_better/load.sql | mysql --local-infile --password=$MYSQL_PASSWORD -u $MYSQL_USER -h $MYSQL_HOST -D $MYSQL_DATABASE

cd ../
python build_indices.py
