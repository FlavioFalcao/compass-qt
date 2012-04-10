# Copyright (c) 2012 Nokia Corporation.

QT       += declarative opengl xml
CONFIG   += qt-components
CONFIG   += mobility
MOBILITY += sensors systeminfo location multimedia #feedback
# feedback is commented out due to the problems on feedback API

TARGET = compass
TEMPLATE = app

VERSION = 2.1

HEADERS += \
    arc.h \
    qmlloader.h \
    persistentstorage.h

SOURCES += \
    main.cpp \
    qmlloader.cpp \
    persistentstorage.cpp

OTHER_FILES += \
    qml/symbian/*.* \
    qml/harmattan/*.* \
    qml/common/*.* \
    qtc_packaging/debian_harmattan/*

symbian {
    TARGET = Compass
    TARGET.UID3 = 0xE4B73955
    TARGET.CAPABILITY = NetworkServices \
                        Location

    TARGET.EPOCSTACKSIZE = 0x14000
    TARGET.EPOCHEAPSIZE = 0x1000 0x1800000 # 24MB

    !contains(SYMBIAN_VERSION, Symbian3) {
        message(Symbian^1)

        # No OpenGL for Symbian^1
        QT -= opengl
        DEFINES += QT_NO_OPENGL
    }

    # To lock the application to portrait orientation
    LIBS += -lcone -leikcore -lavkon

    ICON = icons/compass.svg

    # The beep is used in calibration, will install to application's
    # private folder.
    sound.sources = beep.wav
    sound.path = !:/private/E4B73955

    # Deploy the symbian qml files
    qmlfiles.sources = qml/common qml/symbian qml/images
    qmlfiles.path = qml

    DEPLOYMENT += sound qmlfiles
}

# Harmattan
unix:!symbian:!maemo5 {
    message(Harmattan build)
    DEFINES += Q_WS_HARMATTAN

    CONFIG += qdeclarative-boostable

    target.path = /opt/compass/bin

    qml.files = qml/common qml/harmattan qml/images
    qml.path = /opt/compass/qml

    desktopfile.files = qtc_packaging/debian_harmattan/$${TARGET}.desktop
    desktopfile.path = /usr/share/applications

    icon.files = icons/compass.png
    icon.path = /usr/share/icons/hicolor/80x80/apps

    # The beep is used in calibration
    sound.files = beep.wav
    sound.path = /opt/compass/bin

    # Classifies the application as a game, allows the beep to be heard.
    gamingclassify.files = qtc_packaging/debian_harmattan/compass.conf
    gamingclassify.path = /usr/share/policy/etc/syspart.conf.d

    INSTALLS += \
        target \
        qml \
        desktopfile \
        icon \
        sound \
        gamingclassify
}
