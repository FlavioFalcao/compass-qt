# Copyright (c) 2011 Nokia Corporation.

QT       += declarative opengl xml
CONFIG   += qt-components
CONFIG   += mobility
MOBILITY += sensors systeminfo location multimedia #feedback
# feedback is commented out due to the problems on feedback API

TARGET = compass
TEMPLATE = app

VERSION = 1.3

HEADERS += \
    arc.h \
    qmlloader.h \
    persistentstorage.h

SOURCES += \
    main.cpp \
    qmlloader.cpp \
    persistentstorage.cpp

OTHER_FILES += \
    qml/*.qml \
    backup_registration.xml


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

    # The beep is used in calibration, will install to application's private folder.
    sound.sources = beep.wav
    sound.path = !:/private/E4B73955

    # Deploy the qml folder recursively
    qmlfiles.sources = qml

    # The backup and restore functionality, will install to application's private folder.
    backup.sources = backup_registration.xml
    backup.path = !:/private/E4B73955

    DEPLOYMENT += sound backup qmlfiles
}

# Harmattan
unix:!symbian:!maemo5 {
    message(Harmattan build)
    DEFINES += Q_WS_HARMATTAN

    OTHER_FILES += \
        qml/harmattan.qml

    target.path = /opt/usr/bin

    desktopfile.files = qtc_packaging/debian_harmattan/$${TARGET}.desktop
    desktopfile.path = /usr/share/applications

    icon.files = icons/compass.png
    icon.path = /usr/share/icons/hicolor/64x64/apps

    sound.files = beep.wav
    sound.path = /opt/usr/bin

    INSTALLS += \
        target \
        desktopfile \
        icon \
        sound
}
