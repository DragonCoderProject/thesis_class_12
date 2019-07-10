import QtQuick 2.12
import QtQuick.Controls 2.2
import QtLocation 5.12
import QtPositioning 5.12
import QtQuick.Dialogs 1.3
import SqlQueryModel 1.0
import SerialPort 1.0

ApplicationWindow {
    id: app_window
    visible: true
    width: 900 //Breite des Fensters
    height: 800 //Höhe des Fensters
    title: qsTr("Navigation") //Titel

    SerialPort {
        id:serialPort
    }

    SqlQueryModel{
        id: querymodel
    }

    Loader { //QtQuick Komponent, der verantwortlich ist andere kommpoente aus einem weiteren datei.qml zu laden
        id: loadRoutingMenu
        source: "menu/routingMenu.qml"
        active: true
    }

    Text {
        id: coordinatesOutputField
    } //Text, der koordinate aus  Maus ablesen sollte

    PositionSource {
        id: src //Name des PositionSource's, die danach für erkennung benutzt wird
        updateInterval: 1000 //wie oft sollte es unsere Lokalisation updaten
        active: true //wir schalten die Lokalisierung an
        //name:"SerialPortNmea" //ermöglicht Zugriff auf serialport mit nmea standar
        valid: true
        nmeaSource: "/dev/serial/by-path/pci-0000:00:14.0-usb-0:2:1.0-port0"
        name: "SerialPortNmea"



        onPositionChanged: { //wenn wir das signal bekommen
            var coord = position.coordinate;
            console.log("error value: " + src.sourceError) //zeigt uns evetuelle Fehler, die aufgetreten sind
            console.log("Coordinate:", coord.longitude, coord.latitude); //sollte unsere Länge und Breite im consol schreiben

            map_id.center = coord; // bewegt uns, bzw unseres zoom zu unsere Lokalisation
            marker_id.coordinate = coord;

            if (src.sourceError != 0){ //wen PositionSource Fehler findet, sollte das MessageDialog Fenster zeigen
                messageDialogPositionSourceProblem.visible = true
            } //if
        }
    } //PositionSource

    MessageDialog {
        id: messageDialogPositionSourceProblem
        title: "Problem with the GPS-Modul"
        text: "The GPS.Modul doesn't found."
        standardButtons: standardButton.Ok
        visible: false
    } //Bei Probleme mit GPS Modul zeigt Dialogfenster
    MessageDialog {
        id: messageDialogQueryProblem
        title: "Problem with lokalisation"
        text: "The GPS coordinates can not be found."
        standardButtons: standardButton.Ok
        visible: false
    } //Bei Probleme mit Lokalisation zeigt Dialogfenster

    Rectangle { //hier als eine Rahme für das map
        id: mapRectangleID
        width: app_window.width //Übernahme des breite von ApplicationWindow
        height: app_window.height - 20 //Höhe des ApplicationWindow - 20 pixel, die für Button reserviert sind
        y: 20 //Verschiebung an y-achse um 20 Pixel nach unten

        property var wayPointStart: undefined //Variable die unsere Koordinate vom Startpunkt behält und als Anfangswert nicht definiert erhält
        property var wayPointEnd: undefined //Variable die unsere Koordinate vom Endspunkt behält und als Anfangswert nicht definiert erhält
        Item {
            id: name
            property var coordi: undefined
        }


        function queryRoute () {
            if (wayPointStart === undefined || wayPointEnd === undefined){ //man guck, ob beide Punkte Koordinate erhalten, wen nicht
                messageDialogQueryProblem.visible = true //hier wird MessageDialog angeschaltet um es den nutzer zu sagen, dass Probleme aufgetreten sind
                return
            } else{
            routeQuery.addWaypoint(wayPointStart)
            routeQuery.addWaypoint(wayPointEnd)
            routeQuery.travelModes = RouteQuery.PedestrianTravel
            routeBetweenPoints.update()
            }
        } //Die funktion sollte ein Weg zwischen 2 Punkte zeichnen

        GeocodeModel{
            id: startPointGeocodeModel
            plugin: map_id.plugin
            autoUpdate: true
            onLocationsChanged: {
                mapRectangleID.wayPointStart = get(0).coordinate//Konventiert die Adresse auf Koordinate
                mapRectangleID.queryRoute()
            }
        } //Kovertiert Adresse auf Koordinate

        GeocodeModel{
            id: endPointGeaocodeModel
            plugin: map_id.plugin
            autoUpdate: true
            onLocationsChanged: {
                mapRectangleID.wayPointEnd = get(0).coordinate //Konventiert die Adresse auf Koordinate
                mapRectangleID.queryRoute()
            }
        } //Kovertiert Adresse auf Koordinate

        Component.onCompleted: {
            startPointGeocodeModel.query = 'bcc berlin' //wir geben die Adressen an GecodeModel, dass es letzendlich auf die Koordinate konventiert
            endPointGeaocodeModel.query = 'Gewandhaus Leipzig'
        }


        RouteModel { //durch das Route Model, können wir 2 Punkte hinzufügen, die danach mit dem MapItemView verbunden werden
               id: routeBetweenPoints
               plugin: map_id.plugin
               query: RouteQuery {id: routeQuery }

               Component.onCompleted: {
               }
           } //start and end point




        Map {
            id: map_id
            anchors.fill: parent
            plugin: Plugin {
                name: "osm" //plugin, das die OpenStreetMaps included
            }
            //center: QtPositioning.coordinate(51.1913436, 12.1632954) //Koordinaten Angabe für Anfangsort (Am kleinen Feld 3, 04205 Leipzig, Germany)
            zoomLevel: 60

            MouseArea
            {
                anchors.fill: map_id
                hoverEnabled: true
                property var coordinate: map_id.toCoordinate(Qt.point(mouseX, mouseY))
                Label {
                        x: parent.mouseX - width
                        y: parent.mouseY - height - 5
                        text: "lat: %1; lon:%2".arg(parent.coordinate.latitude).arg(parent.coordinate.longitude)
                        visible: true
                    }
            } //Zeigt die Koordinaten in Stelle, wo die Maus sich befindet

            MapItemView { //Damit zeichnen wir ein Weg von Daten aus DB
                model: querymodel
                delegate: MapCircle {
                    id: oldWay
                    center: QtPositioning.coordinate(latitude, longitude) //wir setzen die Koordinate
                    radius: 20000.0 //in Meter auf der Map
                    color: 'blue'
                    border.width: 1
                }
            } //MapItemView

            MapQuickItem { //Marker, der unsere Position, bzw Standort kennzeichnet
                id: marker_id
                sourceItem: Image {
                    id: endPointImage
                    source: "assets/marker.png"
                    width: 30.125
                    height: 26.125
                } //size and position of maker
                anchorPoint.x: endPointImage.width / 2
                anchorPoint.y: endPointImage.height
            } //MapQuickItem


            MapItemView {
                model: routeBetweenPoints
                delegate: Component {
                        MapRoute {
                            route: routeData
                            line.color: "red"
                            line.width: 10
                        }
                } //Component
           }//Linie, die beide punkte verbindet

            Rectangle {
                    id: if_coordOfMouse
                    width: 100
                    height: 22
                    border.color: 'gray'
                    border.width: 2
                    x: app_window.width - if_coordOfMouse.width
                    y: app_window.height / 7
                    visible: false

                    TextInput {
                        id: txt_coordOfMouse
                        anchors.fill: parent
                        anchors.margins: 4
                    }
            }

        } //Map
    } //Rectangle

    /*Address Komponente*/
    Address {
        id: fromAddress
        city: ""
        country: ""
        street: ""
        postalCode: ""
    } //fromAddress

    Address {
        id: toAddress
        country: ""
        city: ""
        street: ""
        postalCode: ""
    } //toAddress

    /* BUTTON SECTION */
    Button {
        id: btn_close
        width: 100
        height: 20
        text: "Close"

        onClicked: {
            Qt.quit()
        }
    }

    Button {
        id: btn_routing
        width: 200
        height: 20
        x:100
        text: "Routing"

        onClicked: {
            loadRoutingMenu.item.open() //öffnet das Menu aus
        }
    }
    Button {
        id: btn_getCoordinates
        width: 400
        height: 20
        x:300
        text: "Get coordinates"
        visible: true;

        onClicked: {
            menu_getCoordinates.open()
        }
    }
    Button {
        id: btn_drawWay
        width: parent.width - x
        height: 20
        x:700
        text: "Draw way"
        visible: true;

        onClicked: {
            menu_drawWay.open();
        } //onClicked bei MenuItem
    } //Button
    /********************************************MENU********************************************/
    Menu {
        id: menu_getCoordinates
        y:btn_getCoordinates.y + 20
        x:btn_getCoordinates.x
        width: btn_getCoordinates.width

        MenuItem {
            text: "Get coordinates of addresse"
            onTriggered: {
            } //onClicked bei MenuItem

        }
    } //Menu

    Menu {
        id: menu_drawWay
        y:btn_drawWay.y + 20
        x:btn_drawWay.x
        MenuItem {
            text: "Draw old way"

            onTriggered: {
                querymodel.query = "select * from coordinates" //wir liefern Daten aus der Tabelle, wo es generirte Daten sind
            }
        }
        MenuSeparator {} //Zeichnt die Linie zwischen 2 MenuItems
        MenuItem {
            text: "Routing beetwen 2 points"
            onTriggered: {
                mapRectangleID.queryRoute() //Abruf der Funktion
            } //onClicked bei MenuItem

        }
    } //Menu
} //ApplicationWindow
