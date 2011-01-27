#include "compassfilter.h"

CompassFilter::CompassFilter()
{
    m_ScreenSaver.setScreenSaverInhibit();
}


bool CompassFilter::filter(QCompassReading *reading)
{
    emit azimuthChanged(reading->azimuth(), reading->calibrationLevel());
    return false;
}
