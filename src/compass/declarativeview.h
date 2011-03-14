/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#ifndef DECLARATIVEVIEW_H
#define DECLARATIVEVIEW_H

#include <QDeclarativeView>

class DeclarativeView : public QDeclarativeView
{
    Q_OBJECT

public:
    explicit DeclarativeView(QWidget *parent = 0);

protected:

    qreal totalScaleFactor;

    bool event(QEvent *event);

signals:
    void scaleFactor(const QVariant &scale);
    void scaleFactorEnd(const QVariant &scale);
};

#endif // DECLARATIVEVIEW_H
