#ifndef SCREENSAVERINHIBITER_H
#define SCREENSAVERINHIBITER_H

#include <QObject>
#include <QSystemScreenSaver>

QTM_USE_NAMESPACE

class ScreenSaverInhibiter : public QObject
{
    Q_OBJECT
public:
    explicit ScreenSaverInhibiter(QObject *parent = 0);

signals:

public slots:
    void screenSaverInhibit(const QVariant &inhibit);

protected:
    QSystemScreenSaver *m_ScreenSaver;
};

#endif // SCREENSAVERINHIBITER_H
