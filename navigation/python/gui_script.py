#!/usr/bin/python
# coding=utf-8

from appJar import gui
import subprocess
import read
import os

absoluth_path = ''
absoluth_path = read.read_absoluth_path ()
data_generator = 'navigation/python/data_generator.py'
get_data = 'navigation/python/send_data_to_database.py'
start_program = 'build-navigation-Desktop_Qt_5_12_0_GCC_64bit-Debug/navigation'

def press(button): #Funktion die checkt, ob das Button gedrückt wurde
    if (button == "Data generator"):
        subprocess.Popen('python %s%s' %(absoluth_path, data_generator), stdout=subprocess.PIPE, shell=True) #Datengenerator
    elif (button == "Daten sammeln"):
        subprocess.Popen('python %s%s' %(absoluth_path, get_data), stdout=subprocess.PIPE, shell=True) #startet das Program
    elif (button == "Starte program"):
        subprocess.Popen('%s%s' %(absoluth_path, start_program), stdout=subprocess.PIPE, shell=True) #startet das program
        

app = gui("Navigation menu", "400x100")
app.setBg("orange") #Hintergrundfarbe
app.setFont(18)#Schriftgröße
app.addButtons(["Data generator", "Daten sammeln", "Starte program"], press) #Hier fügt man die Buttons auf Oberfläche zu
app.go()


