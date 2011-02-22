#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QDeclarativeView>
#include <QTouchEvent>
#include <QVariant>
#include <QDebug>


class DeclarativeView : public QDeclarativeView
{
    Q_OBJECT

public:
    explicit DeclarativeView(QWidget *parent = 0)
        : QDeclarativeView(parent)
    {
        setAttribute(Qt::WA_AcceptTouchEvents);
        totalScaleFactor = 1;
    }

protected:

    qreal totalScaleFactor;

    bool event(QEvent *event)
    {
        switch (event->type()) {
        case QEvent::TouchBegin:
        case QEvent::TouchUpdate:
        case QEvent::TouchEnd: {
            QTouchEvent *touchEvent = static_cast<QTouchEvent *>(event);
            QList<QTouchEvent::TouchPoint> touchPoints = touchEvent->touchPoints();

            if (touchPoints.count() == 2) {
                // determine scale factor
                const QTouchEvent::TouchPoint &touchPoint0 = touchPoints.first();
                const QTouchEvent::TouchPoint &touchPoint1 = touchPoints.last();

                qreal currentScaleFactor =
                        QLineF( touchPoint0.pos(), touchPoint1.pos()).length()
                        / QLineF(touchPoint0.startPos(), touchPoint1.startPos()).length();

                QLineF l = QLineF(touchPoint0.pos(), touchPoint1.pos());
                l.setLength(l.length() * 0.5);


                if (touchEvent->touchPointStates() & Qt::TouchPointReleased) {
                    // if one of the fingers is released, remember the current scale
                    // factor so that adding another finger later will continue zooming
                    // by adding new scale factor to the existing remembered value.
                    totalScaleFactor *= currentScaleFactor;
                    currentScaleFactor = 1;
                }

                //emit scaleFactor(QVariant(totalScaleFactor * currentScaleFactor), QPointF(l.x2(), l.y2()));
                emit scaleFactor(totalScaleFactor * currentScaleFactor, QPointF(l.x2(), l.y2()));
            }

            return true;
        }

        default:
            break;
        }

        return QDeclarativeView::event(event);
    }

signals:
    void scaleFactor(qreal scale, const QPointF &point);
};


namespace QtMobility {
    class QCompass;
    class QGeoServiceProvider;
    class QGeoMappingManager;
    class QGraphicsGeoMap;
}

class CompassFilter;



class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

public slots:
    void scaleChanged(qreal scale, const QPointF &center);

protected:
    DeclarativeView *view;
    CompassFilter *filter;
    QtMobility::QCompass *compass;
    QtMobility::QGeoServiceProvider *serviceProvider;
    QtMobility::QGeoMappingManager *manager;
    QtMobility::QGraphicsGeoMap *geoMap;

    bool viewportEvent(QEvent *event);
};



#endif // MAINWINDOW_H
