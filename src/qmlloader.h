/**
 * Copyright (c) 2012 Nokia Corporation.
 */

#ifndef QMLLOADER_H
#define QMLLOADER_H

#include <QObject>

class QDeclarativeItem;
class QDeclarativeView;

class QMLLoader : public QObject
{
    Q_OBJECT
public:
    QMLLoader(QDeclarativeView *view);

    void loadSplashScreen();

signals:

public slots:
    void loadMainQML();
    void destroySplashScreen();

protected:
    QDeclarativeView *m_View;
    QDeclarativeItem *m_SplashItem;
    QDeclarativeItem *m_MainItem;
};

#endif // QMLLOADER_H
