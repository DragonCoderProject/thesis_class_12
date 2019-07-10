#!/usr/bin/python
#coding=utf-8
import serial
import time
import sqlite3
import read

absoluth_path = (read.read_absoluth_path ())
rest = "navigation/datenbank/NavigationData.db"
database_name = ('%s%s'%(absoluth_path,rest))#Ort wo wir unseres DB halten

table_name = 'coordinates'
latitude_column = 'latitude'
longtitude_column = 'longitude'
data_column = 'datum'
localtime_column = 'localtime'


goToInformationOfGPS = serial.Serial("/dev/ttyUSB0",  baudrate = 9600)#Zugriff auf das USB-Port und Schrittgeschwindigkeit auf 9600 Baud gesetzt wird

while True: #eine unendliche schleife
    #time.sleep(10) # wir lassen das Programm für 10s einschalfen = jeder 10S werden die Daten in DB hinzugefügt
    line = goToInformationOfGPS.readline()

    information = line.split(",".encode()) #wir sagen, mit was die Daten in dem String getrennt wurden

    if (information[0] =="$GPRMC"): #wir suchen in dem NMEA (National Marine Electronics Association) Daten das Recommended minimum specific GPS/Transit data, wenn gefunden wird
        if (information[2]=="A"): #wenn die Zweite Element = A ist, dann
            try:
                print (information [3] , information [4]) #Druck in Console Breite aus
                print (information [5] , information [6]) #Druck in Console Länge aus
                print (time.strftime("%d-%m-%Y", time.localtime()))
                print (time.strftime("%H-%M-%S", time.localtime()))
                try:
                    x = float(information [3]) / 100 #Daten die wir aus dem serialport bekommen , teilen durch 100 um es in grad zu bekommen
                    y = float(information [5]) / 100 #Daten die wir aus dem serialport bekommen , teilen durch 100 um es in grad zu bekommen
                    d = time.strftime("%d-%m-%Y", time.localtime()) #Datum Tag-Monat-Jahr
                    l = time.strftime("%H-%M-%S", time.localtime()) #localtime Stunden:Minuten:Sekunden
                except Error:
                    print 'error'
                finally:
                    try:
		                connection = sqlite3.connect(database_name) #Erstellung der Verbindung
		                cursor = connection.cursor() #The cursor method accepts a single optional parameter factory. If supplied, this must be a callable returning an instance of Cursor or its subclasses.
		                cursor.execute('''INSERT INTO {tbn}( {ltn}, {longn}, {datum}, {localtime} ) VALUES (  {x1}, {y1}, {d1}, {l1} )'''.format(tbn = table_name, ltn = latitude_column, longn = longtitude_column, datum = data_column, localtime = localtime_column, x1 = x, y1 = y, d1 = d, l1 = l))
		                connection.commit() #Speicher die Datensaetze
                    except Exception as e:
                    # Diese methode liefert alle Veraenderungen zurueck, wenn ein Fehler vorkommt
                        connection.rollback()
                        raise e
                    finally:
                    # Schliesst die verbindung mit Datenbank
                        connection.close()
            except (ValueError):
                pass
    
