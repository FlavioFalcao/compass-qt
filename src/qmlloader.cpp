/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#include <QtDeclarative>
#include "arc.h"
#include "persistentstorage.h"
#include "qmlloader.h"


/*!
  \class QMLLoader
  \brief Handles the loading of the splash screen and the main qml.
*/


/*!
  Constructor.
*/
QMLLoader::QMLLoader(QDeclarativeView *view)
    : m_View(view)
{
}


/*!
  Loads splash screen, also connects the splash screens hidden signal to this
  objects destroySplashScreen slot, so when the splash screen has animated
  away it will be destroyed.
*/
void QMLLoader::loadSplashScreen()
{
    QString splashQmlFile = "qml/common/SplashScreen.qml";

    QDeclarativeComponent splashComponent(m_View->engine(),
                                          QUrl::fromLocalFile(splashQmlFile));

    m_SplashItem = qobject_cast<QDeclarativeItem *>(splashComponent.create());

    connect(m_SplashItem, SIGNAL(hidden()), this, SLOT(destroySplashScreen()),
            Qt::QueuedConnection);

    m_View->scene()->addItem(m_SplashItem);
}


/*!
  Loads the main QML file while the splash screen is being shown.
*/
void QMLLoader::loadMainQML()
{
    qmlRegisterType<Arc>("CustomElements", 1, 0, "Arc");
    qmlRegisterType<PersistentStorage>("CustomElements", 1, 0,
                                       "PersistenStorage");

    // Tell the QML side the path the app exist, this will be used to find
    // out the beep.wav which is used in calibration.
#ifdef Q_WS_HARMATTAN
    m_View->rootContext()->setContextProperty("appFolder", "file://"
                                              + qApp->applicationDirPath()
                                              + QDir::separator());
#else
    m_View->rootContext()->setContextProperty("appFolder",
                                              m_View->engine()->baseUrl()
                                              .toString());
#endif

#ifdef Q_WS_HARMATTAN
    QString mainQmlFile =
            qApp->applicationDirPath() + "/../qml/harmattan/Main.qml";
#else
    QString mainQmlFile = "qml/symbian/Main.qml";
#endif


    QDeclarativeComponent component(m_View->engine(),
                                    QUrl::fromLocalFile(mainQmlFile));

    if (component.status() == QDeclarativeComponent::Error) {
        qDebug() << "Error(s): " << component.errors();
        return;
    }

    m_MainItem = qobject_cast<QDeclarativeItem*>(component.create());

    if (m_MainItem == NULL) {
        qDebug() << "MainItem is NULL";
        return;
    }

    m_View->scene()->addItem(m_MainItem);

    // Framework connections
    connect((QObject*)m_View->engine(), SIGNAL(quit()),
            qApp, SLOT(quit()));

#ifdef Q_OS_SYMBIAN
    // Begin the hide animation of the splash screen
    QMetaObject::invokeMethod(m_SplashItem, "startHideAnimation");
#endif
}


/*!
  Destroys the splash screen.
*/
void QMLLoader::destroySplashScreen()
{
    m_View->scene()->removeItem(m_SplashItem);
    delete m_SplashItem;
    m_SplashItem = 0;
}
