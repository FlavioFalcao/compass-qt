#include "compassfilter.h"
#include <QDebug>

CompassFilter::CompassFilter()
{
    m_ScreenSaver.setScreenSaverInhibit();
}

bool CompassFilter::filter(QCompassReading *reading)
{
    emit azimuthChanged(reading->azimuth(), reading->calibrationLevel());
    return false;
}
