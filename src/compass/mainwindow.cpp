/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QtGui>
#include <QtDeclarative>
#include "arc.h"
#include "declarativeview.h"
#include "mainwindow.h"
#include "compassfilter.h"


#ifndef QT_NO_OPENGL
#include <QGLWidget>
#endif

QTM_USE_NAMESPACE


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    view.reset(new DeclarativeView);
    view->engine();

    orientationSensor.reset(new QOrientationSensor);
    orientationFilter.reset(new OrientationFilter);
    orientationSensor->addFilter(orientationFilter.data());
    orientationSensor->start();

    compass.reset(new QCompass);
    compassFilter.reset(new CompassFilter);
    compass->addFilter(compassFilter.data());
    compass->start();

    geoPositionInfoSource.reset(QGeoPositionInfoSource::createDefaultSource(this));
    geoPositionInfoSource->setUpdateInterval(5000);

    qmlRegisterType<Arc>("CustomElements", 1, 0, "Arc");
    setCentralWidget(view.data());

#ifndef QT_NO_OPENGL
    // Use QGLWidget to get the opengl support if available
    QGLFormat format = QGLFormat::defaultFormat();
    format.setSampleBuffers(false);

    QGLWidget *glWidget = new QGLWidget(format);
    glWidget->setAutoFillBackground(false);
    view->setViewport(glWidget);     // ownership of glWidget is taken
#endif

    view->setSource(QUrl("qrc:/qml/Ui.qml"));
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);

    QObject *rootObject = dynamic_cast<QObject*>(view->rootObject());

    connect(orientationFilter.data(), SIGNAL(orientationChanged(const QVariant&)),
            rootObject, SLOT(orientationChanged(const QVariant&)));
    connect(compassFilter.data(), SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
            rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));
    connect(rootObject, SIGNAL(inhibitScreensaver(const QVariant&)),
            compassFilter.data(), SLOT(screenSaverInhibit(const QVariant&)));
    connect(view.data(), SIGNAL(scaleFactor(const QVariant&)),
            rootObject, SLOT(scaleChanged(const QVariant&)));
    connect(view.data(), SIGNAL(scaleFactorEnd(const QVariant&)),
            rootObject, SLOT(scaleChangedEnd(const QVariant&)));

    // GPS connections
    connect(geoPositionInfoSource.data(), SIGNAL(positionUpdated(const QGeoPositionInfo&)),
            this, SLOT(positionUpdated(const QGeoPositionInfo&)));
    connect(geoPositionInfoSource.data(), SIGNAL(updateTimeout()),
            this, SLOT(updateTimeout()));

    connect(this, SIGNAL(position(const QVariant&, const QVariant&, const QVariant&, const QVariant&)),
            rootObject, SLOT(position(const QVariant&, const QVariant&, const QVariant&, const QVariant&)));

    connect((QObject*)view->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));

    QGeoPositionInfo geoPositionInfo = geoPositionInfoSource->lastKnownPosition();
    if(geoPositionInfo.isValid()) {
        QGeoCoordinate coordinate = geoPositionInfo.coordinate();
        emit position(0, coordinate.latitude(), coordinate.longitude(),
                      geoPositionInfo.attribute(QGeoPositionInfo::HorizontalAccuracy));
    }

    geoPositionInfoSource->startUpdates();
}


MainWindow::~MainWindow()
{
}


void MainWindow::positionUpdated(const QGeoPositionInfo &update)
{
    qreal accuracy = update.attribute(QGeoPositionInfo::HorizontalAccuracy);
    qDebug() << "Got GPS position, accuracy: " << accuracy;

    uint secsFrom1970 = QDateTime::currentDateTime().toTime_t();
    QGeoCoordinate c = update.coordinate();

    emit position(secsFrom1970, c.latitude(), c.longitude(), accuracy);
}



void MainWindow::updateTimeout()
{
    qDebug() << "GPS timeout";
    // We could show GPS not available icon now..
}
