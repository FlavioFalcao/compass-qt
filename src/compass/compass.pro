# Copyright (c) 2011 Nokia Corporation.

QT       += core gui declarative opengl
CONFIG   += mobility
MOBILITY += sensors systeminfo location feedback multimedia

TARGET = compass
TEMPLATE = app

VERSION = 0.2

HEADERS += compassfilter.h \
           arc.h \
           mainwindow.h \
           declarativeview.h \
           orientationfilter.h

SOURCES += main.cpp \
           compassfilter.cpp \
           mainwindow.cpp \
           declarativeview.cpp

OTHER_FILES += qml/Ui.qml \
               qml/Compass.qml \
               qml/CalibrationView.qml \
               qml/SettingsPane.qml \
               qml/Button.qml \
               qml/PannableMap.qml \
               qml/InfoView.qml \
               qml/settings.js \
               qml/BorderDialog.qml

RESOURCES = compass.qrc

symbian {
    TARGET = Compass
    TARGET.CAPABILITY = NetworkServices \
                        Location

    # To lock the application to landscape orientation
    LIBS += -lcone -leikcore -lavkon
    ICON = icons/compass.svg

    TARGET.EPOCHEAPSIZE = 0x100000 0x2000000
    TARGET.EPOCSTACKSIZE = 0x14000

    BLD_INF_RULES.prj_exports += "beep.wav ../winscw/c/Data/compass/beep.wav"

    sound.sources = beep.wav
    sound.path = c:/System/compass

    DEPLOYMENT += sound
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/bin
    } else {
        target.path = /usr/local/bin
    }
    INSTALLS += target
}
