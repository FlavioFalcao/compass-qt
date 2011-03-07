#include <QtGui>
#include "declarativeview.h"

DeclarativeView::DeclarativeView(QWidget *parent)
    : QDeclarativeView(parent)
{
    setAttribute(Qt::WA_AcceptTouchEvents);
    totalScaleFactor = 14;
}


bool DeclarativeView::event(QEvent *event)
{
    switch (event->type()) {
    case QEvent::TouchBegin:
    case QEvent::TouchUpdate:
    case QEvent::TouchEnd: {
        QTouchEvent *touchEvent = static_cast<QTouchEvent*>(event);
        QList<QTouchEvent::TouchPoint> touchPoints = touchEvent->touchPoints();

        if(touchPoints.count() == 2) {
            // Determine scale factor
            const QTouchEvent::TouchPoint &touchPoint0 = touchPoints.first();
            const QTouchEvent::TouchPoint &touchPoint1 = touchPoints.last();

            qreal posLineLength = QLineF(touchPoint0.pos(), touchPoint1.pos()).length();
            qreal startPosLineLength = QLineF(touchPoint0.startPos(), touchPoint1.startPos()).length();

            qreal currentScaleFactor = (posLineLength - ((posLineLength - startPosLineLength) * 0.85)) / startPosLineLength;

            //qreal currentScaleFactor = posLineLength / startPosLineLength;

            if(touchEvent->touchPointStates() & Qt::TouchPointReleased) {
                // if one of the fingers is released, remember the current scale
                // factor so that adding another finger later will continue zooming
                // by adding new scale factor to the existing remembered value.
                totalScaleFactor *= currentScaleFactor;
                if(totalScaleFactor > 18.0) {
                    totalScaleFactor = 18.0;
                }
                currentScaleFactor = 1;

                emit scaleFactorEnd(QVariant(totalScaleFactor));
            }
            else {
                qreal scale = totalScaleFactor * currentScaleFactor;
                if(scale > 18.0) {
                    scale = 18.0;
                }

                emit scaleFactor(QVariant(scale));
            }
        }

        return true;
    }

    default:
        break;
    }

    return QDeclarativeView::event(event);
}
