#include <QtGui>
#include <QDeclarativeEngine>
#include <QDeclarativeView>
#include <QCompass>
#include "arc.h"
#include "mainwindow.h"
#include "compassfilter.h"


#ifndef QT_NO_OPENGL
    #include <QGLWidget>
#endif

QTM_USE_NAMESPACE


MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
{
    view = new QDeclarativeView;
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

    QObject *rootObject = dynamic_cast<QObject*>(view->rootObject());

    QObject::connect(filter, SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
                     rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));

    QObject::connect((QObject*)view->engine(), SIGNAL(quit()),
                     qApp, SLOT(quit()));

    compass->start();
}


MainWindow::~MainWindow()
{
    delete view;
    view = 0;
}


void MainWindow::initializeQMLComponent()
{
}
