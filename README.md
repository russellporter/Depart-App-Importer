GTFS MySQL Importer
====================

Author: Tom Lee (thomas.j.lee@gmail.com),
changes by Russell Porter (contact@russellporter.com) adding support for TransLink GTFS, and a cleaner import procedure

Description
---------------------

This is a simple set of python scripts that will import a GTFS dataset into
a lightweight MySQL database.  The work is based on Washington, DC's
WMATA GTFS dataset, and has not been thoroughly checked for completeness
against the GTFS spec -- some optional fields or tables may not 
currently be supported (but should be trivial to add).

In addition to the GTFS fields, a number of columns have been created
to assist in the conversion of GTFS's string-based date/time 
representations to more useful Unix timestamp-style second counts.

Prerequisites
---------------------

[MySQL](http://mysql.com/downloads/mysql/)

wget ([Mac installer](http://www.statusq.org/archives/2008/07/30/1954/))

python

MySQLdB (Python module), run: `easy_install MySQL-python`

Usage
---------------------

1.  Check sql_better/load.sql IMPORT DATA INFILE, and change the column order to match those of the CSV files you are importing
2.  Edit config.sh with your MySQL server info
3.  Run `sh ./import.sh` in your command line

Todo
---------------------

- GTFS Transfer import
- Automatically match CSV columns