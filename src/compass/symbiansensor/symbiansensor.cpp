#include <QtCore>
#include "symbiansensor.h"

SymbianSensor::SymbianSensor(QObject *parent) :
    QObject(parent)
{
    iSensorchecking = CSensorchecking::NewL(*this);
}

SymbianSensor::~SymbianSensor()
{
    delete iSensorchecking;
    iSensorchecking = NULL;
}


void SymbianSensor::AngleAndAccuracyReceivedL(TInt aAngle, TInt aAccuracyLevel)
{
    // Scale the aAccuracyLevel to the range 0..1
    qreal calibrationLevel = aAccuracyLevel / 3.0;
    emit azimuthChanged(QVariant(aAngle), QVariant(calibrationLevel));
}
