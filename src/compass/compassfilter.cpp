/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#include "compassfilter.h"


CompassFilter::CompassFilter(QObject *parent)
    : QObject(parent)
{
}

bool CompassFilter::filter(QCompassReading *reading)
{
    emit azimuthChanged(reading->azimuth(), reading->calibrationLevel());
    return false;
}
