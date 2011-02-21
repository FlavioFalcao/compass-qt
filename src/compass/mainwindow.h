#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

class QDeclarativeView;
namespace QtMobility { class QCompass; }
class CompassFilter;

class MainWindow : public QMainWindow
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

public slots:
    void initializeQMLComponent();

protected:
    QDeclarativeView *view;
    QtMobility::QCompass *compass;
    CompassFilter *filter;
};



#endif // MAINWINDOW_H
