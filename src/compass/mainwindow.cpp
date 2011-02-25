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
    view = new DeclarativeView;
    view->engine();

    compass = new QCompass;
    filter = new CompassFilter;
    compass->addFilter(filter);
    compass->start();

    geoPositionInfoSource = QGeoPositionInfoSource::createDefaultSource(this);
    geoPositionInfoSource->setUpdateInterval(10000);

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

    view->setSource(QUrl("qrc:/qml/Ui.qml"));
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);

    QObject *rootObject = dynamic_cast<QObject*>(view->rootObject());

    connect(filter, SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
            rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));

    connect(view, SIGNAL(scaleFactor(const QVariant&)),
            rootObject, SLOT(scaleChanged(const QVariant&)));

    connect(geoPositionInfoSource, SIGNAL(positionUpdated(const QGeoPositionInfo&)), this, SLOT(positionUpdated(const QGeoPositionInfo &)));

    connect(this, SIGNAL(position(const QVariant&, const QVariant&)),
            rootObject, SLOT(position(const QVariant&, const QVariant&)));

    connect((QObject*)view->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));

    geoPositionInfoSource->startUpdates();
}


MainWindow::~MainWindow()
{
    if(compass) {
        delete compass;
        compass = 0;
    }

    if(filter) {
        delete filter;
        filter = 0;
    }

    if(view) {
        delete view;
        view = 0;
    }
}


void MainWindow::positionUpdated(const QGeoPositionInfo &update)
{
    QGeoCoordinate c = update.coordinate();
    qDebug() << "Position: " << c.latitude() << ", " << c.longitude();
    emit position(c.latitude(), c.longitude());
}
