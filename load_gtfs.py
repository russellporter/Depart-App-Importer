#!/bin/python

import csv
import MySQLdb
import settings

def is_numeric(s):
    try:
      i = float(s)
    except ValueError:
        # not numeric
        return False
    else:
        # numeric
        return True

def main():
    conn = MySQLdb.connect (host=settings.MYSQL_HOST, user=settings.MYSQL_USER, passwd=settings.MYSQL_PASSWORD, db=settings.MYSQL_DATABASE)
    cursor = conn.cursor()
    
    TABLES = ['trips']

    for table in TABLES:
        print 'processing %s' % table
        f = open('gtfs/%s.txt' % table, 'r')
        reader = csv.reader(f)
        columns = reader.next()
        for row in reader:
            insert_row = []
            for value in row:
                if not is_numeric(value):
                    insert_row.append('"' + MySQLdb.escape_string(value) + '"')
                else:
                    insert_row.append(value)
                    
            insert_sql = "INSERT INTO %s (%s) VALUES (%s);" % (table, ','.join(columns), ','.join(insert_row))        
            cursor.execute(insert_sql)

	cache_sql = "UPDATE stop_times SET stop_times.departure_time_seconds = 3600*CAST(SUBSTRING(stop_times.departure_time FROM 1 FOR 2) AS UNSIGNED) + 60*CAST(SUBSTRING(stop_times.departure_time FROM 4 FOR 2) AS UNSIGNED) + CAST(SUBSTRING(stop_times.departure_time FROM 7 FOR 2) AS UNSIGNED)"   
    cursor.execute(cache_sql)
    cache_sql = "UPDATE stop_times SET stop_times.arrival_time_seconds = 3600*CAST(SUBSTRING(stop_times.arrival_time FROM 1 FOR 2) AS UNSIGNED) + 60*CAST(SUBSTRING(stop_times.arrival_time FROM 4 FOR 2) AS UNSIGNED) + CAST(SUBSTRING(stop_times.arrival_time FROM 7 FOR 2) AS UNSIGNED)"   
    cursor.execute(cache_sql)
    cursor.close ()
    conn.close ()

    
if __name__ == '__main__':
    main()