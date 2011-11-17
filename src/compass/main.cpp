/**
 * Copyright (c) 2011 Nokia Corporation.
 */

#include <QApplication>
#include <QDesktopWidget>
#include <QScopedPointer>

#include "mainwindow.h"

// Lock orientation in Symbian
#ifdef Q_OS_SYMBIAN
#include <eikenv.h>
#include <eikappui.h>
#include <aknenv.h>
#include <aknappui.h>
#endif


int main(int argc, char *argv[])
{
#ifdef Q_OS_SYMBIAN
    // Fixes the bug where UI does not update any more after sending app
    // to background and foreground.
    QApplication::setGraphicsSystem("opengl");
#endif

    QApplication app(argc, argv);

#ifdef Q_OS_SYMBIAN
    // Lock orientation to landscape in Symbian.
    CAknAppUi* appUi = dynamic_cast<CAknAppUi*> (CEikonEnv::Static()->AppUi());

    TRAP_IGNORE(
                if (appUi)
                appUi->SetOrientationL(CAknAppUi::EAppUiOrientationPortrait);
            )
        #endif

            QScopedPointer<MainWindow> mainWindow(new MainWindow);

#if defined(Q_WS_HARMATTAN) || defined(Q_OS_SYMBIAN) || defined(Q_WS_SIMULATOR)
    mainWindow->setGeometry(QApplication::desktop()->screenGeometry());
    mainWindow->showFullScreen();
#else
    mainWindow->setGeometry((QRect(100, 100, 640, 360)));
    mainWindow->show();
#endif

    return app.exec();
}
