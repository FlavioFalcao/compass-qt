/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QtGui>
#include <QtDeclarative>
#include <QGeoPositionInfoSource>
#include <QGeoPositionInfo>
#include <QCompass>
#include <QOrientationSensor>
#include "arc.h"
#include "mainwindow.h"
#include "declarativeview.h"
#include "orientationfilter.h"
#include "compassfilter.h"


#ifndef QT_NO_OPENGL
#include <QGLWidget>
#endif

QTM_USE_NAMESPACE


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    view = new DeclarativeView(this);

    orientationSensor = new QOrientationSensor(this);
    orientationFilter = new OrientationFilter(this);
    orientationSensor->addFilter(orientationFilter);
    orientationSensor->start();

    compass = new QCompass(this);
    compassFilter = new CompassFilter(this);
    compass->addFilter(compassFilter);
    compass->start();

    geoPositionInfoSource = QGeoPositionInfoSource::createDefaultSource(this);
    geoPositionInfoSource->setUpdateInterval(5000);

    qmlRegisterType<Arc>("CustomElements", 1, 0, "Arc");
    setCentralWidget(view);

#ifndef QT_NO_OPENGL
    // Use QGLWidget to get the opengl support if available
    QGLFormat format = QGLFormat::defaultFormat();
    format.setSampleBuffers(false);

    QGLWidget *glWidget = new QGLWidget(format);
    glWidget->setAutoFillBackground(false);
    view->setViewport(glWidget);     // ownership of glWidget is taken
#endif

    // Tell the QML side the path the app exist, this will be used to find out
    // the beep.wav which is used in calibration.
    view->rootContext()->setContextProperty("appFolder",
                                            view->engine()->baseUrl()
                                            .toString());

    view->setSource(QUrl("qrc:/qml/Ui.qml"));
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);

    QObject *rootObject = dynamic_cast<QObject*>(view->rootObject());

    // Sensor connections
    connect(orientationFilter, SIGNAL(orientationChanged(const QVariant&)),
            rootObject, SLOT(orientationChanged(const QVariant&)));
    connect(compassFilter,
            SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
            rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));
    connect(rootObject, SIGNAL(inhibitScreensaver(const QVariant&)),
            compassFilter, SLOT(screenSaverInhibit(const QVariant&)));

    // Multitouch connections
    connect(view, SIGNAL(scaleFactor(const QVariant&)),
            rootObject, SLOT(scaleChanged(const QVariant&)));
    connect(view, SIGNAL(scaleFactorEnd(const QVariant&)),
            rootObject, SLOT(scaleChangedEnd(const QVariant&)));

    // GPS connections
    connect(geoPositionInfoSource,
            SIGNAL(positionUpdated(const QGeoPositionInfo&)),
            this, SLOT(positionUpdated(const QGeoPositionInfo&)));
    connect(geoPositionInfoSource, SIGNAL(updateTimeout()),
            rootObject, SLOT(positionTimeout()));
    connect(this, SIGNAL(position(const QVariant&, const QVariant&,
                                  const QVariant&, const QVariant&)),
            rootObject, SLOT(position(const QVariant&, const QVariant&,
                                      const QVariant&, const QVariant&)));

    // Framework connections
    connect((QObject*)view->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));

    // Apply the screensaver inhibiter if requested on startup
    compassFilter->screenSaverInhibit(
                rootObject->property("screenSaverInhibited"));

    // Query the lask known position
    QGeoPositionInfo geoPositionInfo =
            geoPositionInfoSource->lastKnownPosition();

    if (geoPositionInfo.isValid()) {
        QGeoCoordinate coordinate = geoPositionInfo.coordinate();
        emit position(0, coordinate.latitude(), coordinate.longitude(),
                      geoPositionInfo.attribute(
                          QGeoPositionInfo::HorizontalAccuracy));
    }

    // Start the GPS
    geoPositionInfoSource->startUpdates();
}


MainWindow::~MainWindow()
{
}


void MainWindow::positionUpdated(const QGeoPositionInfo &update)
{
    qreal accuracy = update.attribute(QGeoPositionInfo::HorizontalAccuracy);

    uint secsFrom1970 = update.timestamp().toTime_t();
    QGeoCoordinate c = update.coordinate();

    emit position(secsFrom1970, c.latitude(), c.longitude(), accuracy);
}
