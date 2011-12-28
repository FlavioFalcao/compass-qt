/**
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QApplication>
#include <QDeclarativeView>
#include <QDesktopWidget>
#include <QTimer>
#include "qmlloader.h"


int main(int argc, char *argv[])
{
#ifdef Q_OS_SYMBIAN
    // Fixes the bug where UI does not update any more after sending app
    // to background and foreground.
    QApplication::setGraphicsSystem("opengl");
#endif

    QApplication app(argc, argv);

    QDeclarativeView view;
    view.setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view.setAutoFillBackground(false);

    QMLLoader qmlLoader(&view);

#ifdef Q_OS_SYMBIAN
    qmlLoader.loadSplashScreen();
#endif

    QTimer::singleShot(0, &qmlLoader, SLOT(loadMainQML()));

#if defined(Q_WS_HARMATTAN) || defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    view.setGeometry(QApplication::desktop()->screenGeometry());
    view.showFullScreen();
#else
    view.setGeometry((QRect(100, 100, 640, 360)));
    view.show();
#endif

    return app.exec();
}
