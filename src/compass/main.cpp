/*
 * Copyright (c) 2010 Nokia Corporation.
 */

#include <QtDeclarative>
#include <QtGui>
#include <QCompass>
#include "compassfilter.h"


// Lock orientation in Symbian
#ifdef Q_OS_SYMBIAN
#include <eikenv.h>
#include <eikappui.h>
#include <aknenv.h>
#include <aknappui.h>
#endif

#ifndef QT_NO_OPENGL
    #include <QGLWidget>
#endif

QTM_USE_NAMESPACE


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

#ifdef Q_OS_SYMBIAN
    // Lock orientation to landscape in Symbian
    CAknAppUi* appUi = dynamic_cast<CAknAppUi*> (CEikonEnv::Static()->AppUi());
    TRAP_IGNORE(
        if (appUi)
            appUi->SetOrientationL(CAknAppUi::EAppUiOrientationLandscape);
    )
#endif

    QCompass compass;
    CompassFilter filter;
    compass.addFilter(&filter);

    QDeclarativeView view;
    view.setSource(QUrl("qrc:/qml/Compass.qml"));
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);

#ifndef QT_NO_OPENGL
    /*
    // Use QGLWidget to get the opengl support if available
    QGLFormat format = QGLFormat::defaultFormat();
    format.setSampleBuffers(false);

    QGLWidget *glWidget = new QGLWidget(format);
    glWidget->setAutoFillBackground(false);
    view.setViewport(glWidget);     // ownership of glWidget is taken
    */
#endif

    QObject *rootObject = dynamic_cast<QObject*>(view.rootObject());

    QObject::connect(&filter, SIGNAL(azimuthChanged(const QVariant&, const QVariant&)),
                     rootObject, SLOT(handleAzimuth(const QVariant&, const QVariant&)));

    QObject::connect((QObject*)view.engine(), SIGNAL(quit()),
                     &app, SLOT(quit()));

    compass.start();

#if defined(Q_WS_MAEMO_5) || defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    view.setGeometry(QApplication::desktop()->screenGeometry());
    view.showFullScreen();
#else
    view.setGeometry((QRect(100, 100, 640, 360)));
    view.show();
#endif

    return app.exec();
}
