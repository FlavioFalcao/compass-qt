/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#ifndef COMPASSFILTER_H
#define COMPASSFILTER_H

#include <QCompassFilter>
#include <QSystemScreenSaver>
#include <QVariant>

QTM_USE_NAMESPACE


class CompassFilter :
    public QObject,
    public QCompassFilter
{
    Q_OBJECT

public:
    CompassFilter();
    bool filter(QCompassReading *reading);

signals:
    void azimuthChanged(const QVariant &azimuth, const QVariant &calibrationLevel);

public slots:
    void screenSaverInhibit(const QVariant &inhibit);

protected:
    QSystemScreenSaver *m_ScreenSaver;
};


#endif // COMPASSFILTER_H
