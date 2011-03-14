/*
 * Copyright (c) 2011 Nokia Corporation.
 */

#ifndef LINE_H
#define LINE_H

#include <QDeclarativeItem>
#include <QDebug>
#include <QPainter>

class Arc : public QDeclarativeItem
{
    Q_OBJECT
    Q_PROPERTY(int startAngle READ startAngle WRITE setStartAngle NOTIFY startAngleChanged);
    Q_PROPERTY(int spanAngle READ spanAngle WRITE setSpanAngle NOTIFY spanAngleChanged);
    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged);
    Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged);

public:
    Arc(QDeclarativeItem *parent = 0) :
            QDeclarativeItem(parent),
            m_startAngle(0),
            m_spanAngle(90 * 16),
            m_color(Qt::black),
            m_penWidth(1)
    {
        // Important, otherwise the paint method is never called
        setFlag(QGraphicsItem::ItemHasNoContents, false);
    }

    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
    {
        QPen pen(m_color, m_penWidth);
        painter->setPen(pen);

        if(smooth() == true) {
            painter->setRenderHint(QPainter::Antialiasing, true);
        }

        painter->drawArc(0, 0, width(), height(), m_startAngle, m_spanAngle);
    }


    QRectF boundingRect() const
    {
        return QRectF(-m_penWidth / 2,
                      -m_penWidth / 2,
                      width() + m_penWidth + 1,
                      height() + m_penWidth + 1);

    }

    // Get methods
    int startAngle() const { return m_startAngle; }
    int spanAngle() const { return m_spanAngle; }
    QColor color() const { return m_color; }
    int penWidth() const { return m_penWidth; }

    // Set methods
    void setStartAngle(int startAngle)
    {
        if(m_startAngle == startAngle) return;
        m_startAngle = startAngle;
        emit startAngleChanged();
        update();
    }

    void setSpanAngle(int spanAngle)
    {
        if(m_spanAngle == spanAngle) return;
        m_spanAngle = spanAngle;
        emit spanAngleChanged();
        update();
    }

    void setColor(const QColor &color)
    {
        if(m_color == color) return;
        m_color = color;
        emit colorChanged();
        update();
    }

    void setPenWidth(int newWidth)
    {
        if(m_penWidth == newWidth) return;
        m_penWidth = newWidth;
        emit penWidthChanged();
        update();
    }

signals:
    void startAngleChanged();
    void spanAngleChanged();
    void colorChanged();
    void penWidthChanged();

protected:
    int m_startAngle;
    int m_spanAngle;
    QColor m_color;
    int m_penWidth;
};

QML_DECLARE_TYPE(Arc)

#endif // LINE_H
