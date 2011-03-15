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
    Q_PROPERTY(QColor startColor READ startColor WRITE setStartColor NOTIFY startColorChanged);
    Q_PROPERTY(QColor endColor READ endColor WRITE setEndColor NOTIFY endColorChanged);
    Q_PROPERTY(int penWidth READ penWidth WRITE setPenWidth NOTIFY penWidthChanged);

public:
    Arc(QDeclarativeItem *parent = 0) :
            QDeclarativeItem(parent),
            m_startAngle(90),
            m_spanAngle(270),
            m_startColor(Qt::black),
            m_endColor(Qt::black),
            m_penWidth(1)
    {
        // Important, otherwise the paint method is never called
        setFlag(QGraphicsItem::ItemHasNoContents, false);
    }

    void paint(QPainter *painter, const QStyleOptionGraphicsItem *option, QWidget *widget)
    {
        QConicalGradient gradient(width() / 2, height() / 2, m_startAngle + 90);
        gradient.setColorAt(0, m_endColor);
        gradient.setColorAt(1, m_startColor);

        QBrush brush(gradient);

        QPen pen(brush, m_penWidth, Qt::SolidLine, Qt::FlatCap);
        painter->setPen(pen);

        painter->drawArc(0, 0, width(), height(), (m_startAngle + 90) * 16, m_spanAngle * -16);
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
    QColor startColor() const { return m_startColor; }
    QColor endColor() const { return m_endColor; }
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

    void setStartColor(const QColor &color)
    {
        if(m_startColor == color) return;
        m_startColor = color;
        emit startColorChanged();
        update();
    }

    void setEndColor(const QColor &color)
    {
        if(m_endColor == color) return;
        m_endColor = color;
        emit endColorChanged();
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
    void startColorChanged();
    void endColorChanged();
    void penWidthChanged();

protected:
    int m_startAngle;
    int m_spanAngle;
    QColor m_startColor;
    QColor m_endColor;
    int m_penWidth;
};

QML_DECLARE_TYPE(Arc)

#endif // LINE_H
