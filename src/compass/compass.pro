# Copyright (c) 2011 Nokia Corporation.

QT       += core gui declarative opengl
CONFIG   += mobility
MOBILITY += sensors systeminfo location multimedia #feedback

TARGET = compass
TEMPLATE = app

VERSION = 1.0

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
               qml/BorderDialog.qml \
               backup_registration.xml

RESOURCES = compass.qrc

symbian {
    TARGET = Compass
    TARGET.CAPABILITY = NetworkServices \
                        Location

    # To lock the application to portrait orientation
    LIBS += -lcone -leikcore -lavkon
    ICON = icons/compass.svg

    TARGET.UID3 = 0xE4B73955

    TARGET.EPOCHEAPSIZE = 0x100000 0x2000000
    TARGET.EPOCSTACKSIZE = 0x14000

    BLD_INF_RULES.prj_exports += "beep.wav ../winscw/c/Data/compass/beep.wav"
    BLD_INF_RULES.prj_exports += "backup_registration.xml ../winscw/c/Data/compass/backup_registration.xml"

    # The beep is used in calibration, will install to application's private folder.
    sound.sources = beep.wav
    sound.path = !:/private/E4B73955

    # The backup and restore functionality, will install to application's private folder.
    backup.sources = backup_registration.xml
    backup.path = !:/private/E4B73955

    DEPLOYMENT += sound backup
}

unix:!symbian {
    maemo5 {
        target.path = /opt/usr/bin
    } else {
        target.path = /usr/local/bin
    }
    INSTALLS += target
}
