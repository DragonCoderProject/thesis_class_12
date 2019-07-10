QT += quick qml positioning network location sql serialport#hier binden wir die Elemente, die wir zu Arbeit des Program benötigen
CONFIG += c++11 #hier stellen wir die Version von der Sprache




#Diese Definition, sagt dem Compiler, dass er uns eine Warnung schickt, wenn es man eine veraltete API benutzt
DEFINES += QT_DEPRECATED_WARNINGS


SOURCES += \ #hier binden wir Datein, die Prinzipiel für die Ausführung verantwortlich sind
        main.cpp \
    serialport.cpp

RESOURCES += qml.qrc #restliche/zusätzliche Datein, .qml, Bilder usw.


#Zusätzlicher Pfad zum Ausflösung den QML- Module in QtCreator
QML_IMPORT_PATH = location

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Standardregeln für die Bereitstellung
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \ #Datein .h, .hpp
    sqlquerymodel.h \
    serialport.h

DISTFILES += / # andere Dateien
    marker.png


COPY_CONFIG = datenbank/NavigationData.db
copy_cmd.input = COPY_CONFIG
copy_cmd.output = ${QMAKE_FILE_IN_BASE}${QMAKE_FILE_EXT}
copy_cmd.commands = $$QMAKE_COPY_DIR ${QMAKE_FILE_IN} ${QMAKE_FILE_OUT}
copy_cmd.CONFIG += no_link_no_clean
copy_cmd.variable_out = PRE_TARGETDEPS
QMAKE_EXTRA_COMPILERS += copy_cmd

