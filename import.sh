#!/bin/sh
source config.sh

export PATH=$PATH:/opt/local/lib/mysql5/bin 

# Update mysql settings for python
rm settings.py
echo "MYSQL_USER = '$MYSQL_USER'\nMYSQL_PASSWORD = '$MYSQL_PASSWORD'\nMYSQL_DATABASE = '$MYSQL_DATABASE'\nMYSQL_HOST = '$MYSQL_HOST'" > settings.py

#rm -Rf gtfs/*
cd gtfs

#wget "$GTFS_URL" -O gtfs.zip
#unzip gtfs.zip
#rm gtfs.zip

cat ../sql_better/load.sql | mysql --local-infile --password=$MYSQL_PASSWORD -u $MYSQL_USER -h $MYSQL_HOST -D $MYSQL_DATABASE

cd ../
python build_indices.py
