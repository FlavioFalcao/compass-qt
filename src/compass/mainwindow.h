#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>
#include <QCompass>

QTM_USE_NAMESPACE

class CompassFilter;
class DeclarativeView;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

protected slots:
    void positionUpdated(QGeoPositionInfo update);

signals:
    void position(const QVariant &latitude, const QVariant &longitude);

protected:
    DeclarativeView *view;
    CompassFilter *filter;
    QCompass *compass;
    QGeoPositionInfoSource *geoPositionInfoSource;
};


#endif // MAINWINDOW_H
