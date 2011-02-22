#include <QtGui>
#include <QDeclarativeEngine>
#include <QDeclarativeView>
#include <QCompass>
#include <QGeoServiceProvider>
#include <QGraphicsGeoMap>
#include <QGeoCoordinate>
#include "arc.h"
#include "mainwindow.h"
#include "compassfilter.h"


#ifndef QT_NO_OPENGL
#include <QGLWidget>
#endif

QTM_USE_NAMESPACE


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent), geoMap(0)
{
    view = new DeclarativeView;
    compass = new QCompass;
    filter = new CompassFilter;
    compass->addFilter(filter);

    qmlRegisterType<Arc>("CustomElements", 1, 0, "Arc");

    /*
#ifndef QT_NO_OPENGL
    // Use QGLWidget to get the opengl support if available
    QGLFormat format = QGLFormat::defaultFormat();
    format.setSampleBuffers(false);

    QGLWidget *glWidget = new QGLWidget(format);
    glWidget->setAutoFillBackground(false);
    view->setViewport(glWidget);     // ownership of glWidget is taken
#endif
    */

    setCentralWidget(view);


    view->setSource(QUrl("qrc:/qml/Ui.qml"));
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);

    serviceProvider = new QGeoServiceProvider("nokia");
    manager = serviceProvider->mappingManager();
    geoMap = new QGraphicsGeoMap(manager);
    QGeoCoordinate coordinate(62.2409209, 25.7611155);
    geoMap->resize(640, 360);
    geoMap->setCenter(coordinate);
    geoMap->setZValue(-1);
    view->scene()->addItem(geoMap);


    QObject *rootObject = dynamic_cast<QObject*>(view->rootObject());

    connect(filter, SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
            rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));

    connect(view, SIGNAL(scaleFactor(qreal, const QPointF&)),
            this, SLOT(scaleChanged(qreal, const QPointF&)));

    connect((QObject*)view->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));

    compass->start();
}


MainWindow::~MainWindow()
{
    delete view;
    view = 0;
}


void MainWindow::scaleChanged(qreal scale, const QPointF &center)
{
    if(geoMap == 0) {
        return;
    }

    qreal minimum = geoMap->minimumZoomLevel();
    qreal maximum = geoMap->maximumZoomLevel();

    qDebug() << "Minimum: " << minimum;
    qDebug() << "Maximum: " << maximum;
    qDebug() << "Current: " << geoMap->zoomLevel();

    if(scale > 1) {
        geoMap->setZoomLevel(geoMap->zoomLevel() + 1);
    }
    else {
        geoMap->setZoomLevel(geoMap->zoomLevel() - 1);
    }
}


