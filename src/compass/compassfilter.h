/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#ifndef COMPASSFILTER_H
#define COMPASSFILTER_H

#include <QCompassFilter>
#include <QVariant>

QTM_USE_NAMESPACE


class CompassFilter : public QObject, public QCompassFilter
{
    Q_OBJECT

public:
    CompassFilter(QObject *parent = NULL);
    bool filter(QCompassReading *reading);

signals:
    void azimuthChanged(const QVariant &azimuth,
                        const QVariant &calibrationLevel);
};


#endif // COMPASSFILTER_H
