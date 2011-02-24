#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

namespace QtMobility {
    class QCompass;
}

class CompassFilter;
class DeclarativeView;

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

protected:
    DeclarativeView *view;
    CompassFilter *filter;
    QtMobility::QCompass *compass;
};


#endif // MAINWINDOW_H
