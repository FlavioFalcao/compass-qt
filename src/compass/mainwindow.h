#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QScopedPointer>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>
#include <QGeoPositionInfo>
#include <QCompass>
#include <QOrientationSensor>
#include "compassfilter.h"
#include "orientationfilter.h"
#include "declarativeview.h"

QTM_USE_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

public slots:
    void positionUpdated(const QGeoPositionInfo &update);
    void updateTimeout();

signals:
    void position(const QVariant &latitude, const QVariant &longitude);

protected:
    QScopedPointer<DeclarativeView> view;
    QScopedPointer<QCompass> compass;
    QScopedPointer<QOrientationSensor> orientationSensor;

    QScopedPointer<CompassFilter> compassFilter;
    QScopedPointer<OrientationFilter> orientationFilter;
    QScopedPointer<QGeoPositionInfoSource> geoPositionInfoSource;
};


#endif // MAINWINDOW_H
