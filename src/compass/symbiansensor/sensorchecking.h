#ifndef SENSORCHECKING_H_
#define SENSORCHECKING_H_

#include <sensrvmagneticnorthsensor.h>
#include <sensrvchannelinfo.h>
#include <sensrvdatalistener.h>
#include <sensrvchannelfinder.h>
#include <sensrvpropertylistener.h>
#include <sensrvmagnetometersensor.h>


class MMagneticSensrDataReceiver
{
public:
    /*
    * This function is called when the phone is rotated from Magnetic north
    *  @param aAngle, angle from north direction increase clock wise from 0 to 360.
    *  @param aAccuracyLevel
    *   0 Not calibrated
    *	1 Low calibration.
    *	2 Medium calibration
    *	3 High accuracy
    */
    virtual void AngleAndAccuracyReceivedL(TInt aAngle, TInt aAccuracyLevel) = 0;
};


class CSensorchecking : public CBase, public MSensrvDataListener 
{
public:

    static CSensorchecking* NewL( MMagneticSensrDataReceiver & aAppView );
    virtual ~CSensorchecking();

public:
    // From MSensorDataListener
    void DataReceived(CSensrvChannel& aChannel, TInt aCount, TInt aDataLost );
    void DataError(CSensrvChannel& aChannel, TSensrvErrorSeverity aError);
    void GetDataListenerInterfaceL(TUid aInterfaceUid, TAny*& aInterface);
    
private:

    CSensorchecking(MMagneticSensrDataReceiver &aAppView);
    void ConstructL();

private:

    MMagneticSensrDataReceiver& iDataObserver;

    TInt iMagnetometerCalibrationLevel;
    TInt iMagnetometerAngleFromNorth;
    // Gives the angle from north
    CSensrvChannel* iMagneticNorthSensor;
};


#endif /* SENSORCHECKING_H_ */
