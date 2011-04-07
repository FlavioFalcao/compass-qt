#ifndef SYMBIANSENSOR_H
#define SYMBIANSENSOR_H

#include <QObject>
#include "sensorchecking.h"

class SymbianSensor : public QObject, public MMagneticSensrDataReceiver
{
    Q_OBJECT
public:
    explicit SymbianSensor(QObject *parent = 0);
    virtual ~SymbianSensor();

    virtual void AngleAndAccuracyReceivedL(TInt aAngle, TInt aAccuracyLevel);

signals:
    void azimuthChanged(const QVariant &azimuth,
                        const QVariant &calibrationLevel);

protected:
    CSensorchecking  *iSensorchecking;
};

#endif // SYMBIANSENSOR_H
