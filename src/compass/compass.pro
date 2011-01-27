# Copyright (c) 2010 Nokia Corporation.

QT       += core gui declarative opengl
CONFIG   += mobility
MOBILITY += sensors systeminfo

TARGET = compass
TEMPLATE = app

VERSION = 0.1

HEADERS += compassfilter.h

SOURCES += main.cpp \
           compassfilter.cpp

OTHER_FILES += qml/*.qml

RESOURCES = compass.qrc


symbian {
    TARGET = Compass

    TARGET.CAPABILITY = NetworkServices

    # To lock the application to landscape orientation
    LIBS += -lcone -leikcore -lavkon

    ICON = icons/compass.svg
}
