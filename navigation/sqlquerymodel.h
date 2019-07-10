#ifndef SQLQUERYMODEL_H
#define SQLQUERYMODEL_H

#include <QSqlQuery>
#include <QSqlQueryModel>
#include <QSqlRecord>

class SqlQueryModel : public QSqlQueryModel
{
    Q_OBJECT //Macro ($), die die Klasse SqlQueryModel in der Lage bringt, singals und slots zu verwenden
    Q_PROPERTY(QString query READ queryStr WRITE setQueryStr NOTIFY queryStrChanged)
    Q_PROPERTY(QStringList userRoleNames READ userRoleNames CONSTANT)
public:
    //liefert die Rolle des Models. Das Qt::UserRole ist für User zugeschrieben. Durch die
    //Inkrementierung in Schleife kann man eigene Rollen erstellen.
    using QSqlQueryModel::QSqlQueryModel; //nutze das QSqlQueryModel
    QHash<int, QByteArray> roleNames() const
    {
        QHash<int, QByteArray> roles;
        for (int i = 0; i < record().count(); i ++) {
            roles.insert(Qt::UserRole + i + 1, record().fieldName(i).toUtf8());
        }
        return roles;
    }

    //Die Fuktion lieft das Wert aus einer Zelle auf welche das QModelIndex und ihre Rolle.
    //das Qt::DisplayRole ist für die Sichtbarkeit der Werte in der Tabele verantwortlich ist.
    QVariant data(const QModelIndex &index, int role) const
    { //QModelIndex ist ein intelligenter Zeiger (§)
        QVariant value; //Unie (§) die auf mehrere Datentypen übertragen sein kann
                        //QString, QData, QBool
        if (index.isValid()) {
            if (role < Qt::UserRole) {
                value = QSqlQueryModel::data(index, role);
            } else {
                int columnIdx = role - Qt::UserRole - 1;
                QModelIndex modelIndex = this->index(index.row(), columnIdx);
                value = QSqlQueryModel::data(modelIndex, Qt::DisplayRole);
            }
        }
        return value;
    }

    QString queryStr() const{
        return query().lastQuery();
    } //liefert das letzte Abfrage
    void setQueryStr(const QString &query){
        if(queryStr() == query)
            return;
        setQuery(query);
        emit queryStrChanged();
    } //schickt Abfrage zu Datenbank
    QStringList userRoleNames() const {
        QStringList names;
        for (int i = 0; i < record().count(); i ++) {
            names << record().fieldName(i).toUtf8();
        }
        return names;
    } //Lädt die Rekorden aus Datenank zu eine Liste
signals:
    void queryStrChanged();
};
#endif // SQLQUERYMODEL_H
