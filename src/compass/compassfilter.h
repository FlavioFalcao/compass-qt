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


protected:
    QSystemScreenSaver m_ScreenSaver;
};


#endif // COMPASSFILTER_H
