#ifndef SERIALPORT_H
#define SERIALPORT_H

#include <QSerialPort>

class serialPort : public QSerialPort
{
    Q_OBJECT
public:


    serialPort();
};

#endif // SERIALPORT_H
