#!/usr/bin/python
# coding=utf-8
import time
import sqlite3
import os
import read

absoluth_path = read.read_absoluth_path ()
rest = "navigation/datenbank/NavigationData.db"
database_name = ('%s%s'%(absoluth_path,rest))

table_name = 'coord'
latitude_column = 'latitude'
longtitude_column = 'longitude'

for i in range(1, 400):
    x = 52 - float(i)/10
    y = 12
    print (str(x))
    try:
        connection = sqlite3.connect(database_name)
        cursor = connection.cursor()
        cursor.execute('''INSERT INTO {tbn}( {ltn}, {longn} ) VALUES (  {x1}, {y1})'''\
        .format(tbn = table_name, ltn = latitude_column, longn = longtitude_column, x1 = x, y1 = y))
        connection.commit()
    except Exception as e:
    #liefert zurück alle Änderungen, wenn etwas falsch läuft
        connection.rollback()

#Das Skript ist sollte nur generierte Daten zu den DB schreiben, die man dann bei Präsentation
# nutzen kann 
