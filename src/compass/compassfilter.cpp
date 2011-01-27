#include "compassfilter.h"

CompassFilter::CompassFilter()
{
}


bool CompassFilter::filter(QCompassReading *reading)
{
    emit azimuthChanged(reading->azimuth(), reading->calibrationLevel());
}
