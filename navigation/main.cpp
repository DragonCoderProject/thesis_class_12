#include "sqlquerymodel.h"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QSqlDatabase>
#include <QDebug>

static bool createConnection(const QString & path){ //eine statische Wahrheitsfunktion, die Verbindung mit Datenbank
                                                    //liefert (ob due Verbindung erstellt wurde oder nicht)
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE"); // DataBase Typ
    db.setDatabaseName(path);
    if (!db.open()) {
        qDebug()<<"Cannot open database\n"
                  "Unable to establish a database connection.\n";
        return false;
    }
    return true;
}

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("Navigation"); //hier setzt man Prinzpiel Organisation -name und -domain, die das App schrieb
    QCoreApplication::setOrganizationDomain("www.navigation.com");

    QSerialPort serial;
    serial.setPortName("ttyUSB0");
    serial.startTransaction();
    serial.setBaudRate(9600);
    serial.pinoutSignals();
    serial.Input;



    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    //Enum (§), der die Attribute beschreibt, die das Verhalten für eine Funktion, die
    //für gesamt App gilt, ändert
    //Das Attribut AA_EnableHighDpiScaling ist verantwortlich für Scale in große Auflösung
    qmlRegisterType<SqlQueryModel>("SqlQueryModel", 1, 0, "SqlQueryModel"); //Erstellung des SqlQueryModel
                                                                            //für Nutzung in qml Dateien

    QGuiApplication app(argc, argv); //Ertsellt das QGuiApplication Objekt;

    QQmlApplicationEngine engine; //Erstellung des QQmlApplicationEngine Objekt


    if(!createConnection("NavigationData.db")) //Wenn die Verbindung nicht erstellt wurde, gib wieder -1 (false)
        return -1;

    engine.load(QUrl(QStringLiteral("qrc:/main.qml"))); //Lade das main.qml
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec(); //starte App
}
