#include "sensorchecking.h"
#include <QDebug>

CSensorchecking* CSensorchecking::NewL(MMagneticSensrDataReceiver &aAppView)
{
    CSensorchecking* self = new (ELeave) CSensorchecking(aAppView);

    CleanupStack::PushL(self);
    self->ConstructL();
    CleanupStack::Pop(self);

    return self;
}

void CSensorchecking::ConstructL()
{

    CSensrvChannelFinder *ChannelFinder = CSensrvChannelFinder::NewL();
    
    CleanupStack::PushL(ChannelFinder);
    //List of found channels.
    RSensrvChannelInfoList ChannelInfoList;
    TSensrvChannelInfo ChannelInfo;

    ChannelInfo.iChannelType = KSensrvChannelTypeIdMagneticNorthData;
    ChannelFinder->FindChannelsL(ChannelInfoList, ChannelInfo);
    
    for(TInt i = 0; i < ChannelInfoList.Count(); i++)
    {
        ChannelInfo = ChannelInfoList[i];
        if(ChannelInfo.iChannelType == KSensrvChannelTypeIdMagneticNorthData)
        {
            iMagneticNorthSensor = CSensrvChannel::NewL(ChannelInfoList[i]);
            iMagneticNorthSensor->OpenChannelL();
            iMagneticNorthSensor->StartDataListeningL(this, 1, 1, 0);
        }

    }

    CleanupStack::Pop(ChannelFinder);
    delete ChannelFinder;
    ChannelFinder = NULL;
}


CSensorchecking::CSensorchecking(MMagneticSensrDataReceiver &aAppView)
    : iDataObserver(aAppView)
{
    
    iMagnetometerCalibrationLevel = 0;
    iMagnetometerAngleFromNorth = 0;
    // No implementation required
}


CSensorchecking::~CSensorchecking()
{
    if(iMagneticNorthSensor)
    {
        iMagneticNorthSensor->StopDataListening();
        iMagneticNorthSensor->CloseChannel();
        delete iMagneticNorthSensor;
        iMagneticNorthSensor = NULL;
    }
}


void CSensorchecking::DataReceived(CSensrvChannel& aChannel,
                                   TInt /*aCount*/,
                                   TInt /*aDataLost*/)
{
    
    TSensrvChannelInfo Channelinfo = aChannel.GetChannelInfo();
    if (Channelinfo.iChannelType == KSensrvChannelTypeIdMagneticNorthData)
    {
        //TSensrvMagnetometerAxisData
        TSensrvMagneticNorthData magNorthData;
        TPckg<TSensrvMagneticNorthData>  magNorthPackage(magNorthData);
        aChannel.GetData(magNorthPackage);
        iMagnetometerAngleFromNorth = magNorthData.iAngleFromMagneticNorth;
        TSensrvProperty calibration;
        aChannel.GetPropertyL(KSensrvPropCalibrationLevel,0,calibration);
        calibration.GetValue(iMagnetometerCalibrationLevel);
        TRAPD(err, iDataObserver.AngleAndAccuracyReceivedL(iMagnetometerAngleFromNorth, iMagnetometerCalibrationLevel));
    }
}


void CSensorchecking::DataError(CSensrvChannel& /*aChannel*/,
                                TSensrvErrorSeverity /*aError*/ )
{
}


void CSensorchecking::GetDataListenerInterfaceL( 
    TUid /*aInterfaceUid*/, TAny*& aInterface )
{

    // Set interface as NULL to indicate only default interface currently supported.
    // If new interface(s) is being introduced and application wants to support that
    // aInterfaceUid must be checked and aInterface set accordingly.
    aInterface = NULL;
}
