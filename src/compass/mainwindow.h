/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QGeoPositionInfo>

// Namespace declaration for Qt Mobility
QTM_USE_NAMESPACE

// Forward declarations for QtMobility classes
namespace QtMobility
{
    class QCompass;
    class QOrientationSensor;
    class QGeoPositionInfoSource;
}

class CompassFilter;
class OrientationFilter;
class DeclarativeView;
class ScreenSaverInhibiter;


class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

public slots:
    void positionUpdated(const QGeoPositionInfo &update);

signals:
    void position(const QVariant &time, const QVariant &latitude,
                  const QVariant &longitude, const QVariant &accuracyInMeters);
    void positionTimeout();

protected:
    DeclarativeView *m_view;
    QCompass *m_compass;
    CompassFilter *m_compassFilter;
    ScreenSaverInhibiter *m_screenSaverInhibiter;
    QOrientationSensor *m_orientationSensor;
    OrientationFilter *m_orientationFilter;
    QGeoPositionInfoSource *m_geoPositionInfoSource;
};


#endif // MAINWINDOW_H
