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
};

#endif // DECLARATIVEVIEW_H
