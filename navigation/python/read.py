#!/usr/bin/python
# coding=utf-8
import os
def read_absoluth_path():
    lokation = "" #wir inizialisieren ein String
    script_dir = os.path.dirname(__file__) #script dir ist das gleiche was der Pfad bis zu dem Ordner in dem sich read.py
                                           # Datei befindet.
    rel_path = "config_of_project_lokation.txt"
    abs_file_path = os.path.join(script_dir, rel_path) #hier fügen wir die beide Variablen zusammen um das Abosluter Pfad
                                                       # zu dem Datei haben

    f = open(abs_file_path, 'r') # wir öffnen das Datei auf

    if f.mode == "r": # wenn das geöffnet und bereit zum lesen ist
        lokation = f.read() # lokation = Zeile aus dem Datei
        return (lokation.strip()) #wir liefern die Zeile zurück ohne Zeilenbruch (.strip())

'''
Reintheoretisch um die Daten zu lesen reicht nur dieses Abschnitt:
f = open(abs_file_path, 'r')

    if f.mode == "r":
        lokation = f.read()
        return (lokation.strip())

Aber erstmal muss man der Absoluter Pfad für den Datei eingeben. Da durch ist dieser Abschnitt geschrieben:

lokation = ""
    script_dir = os.path.dirname(__file__)
    rel_path = "config_of_project_lokation.txt"
    abs_file_path = os.path.join(script_dir, rel_path)

Der Abschnitt sollte der absoluter Pfad zu dem Datei config_of_project_lokation.txt erstellen
um ausschliesslich eine Zeile von dem Datei zu lesen. Da datei muss aber von Benutzer editiert werden.
Diese Zeile ist ein relativer Pfad
'''
