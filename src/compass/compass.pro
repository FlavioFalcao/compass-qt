# Copyright (c) 2011 Nokia Corporation.

QT       += core gui declarative opengl
CONFIG   += mobility
MOBILITY += sensors systeminfo location multimedia # feedback
# feedback is commented out due to the problems on feedback API

TARGET = compass
TEMPLATE = app

VERSION = 1.1

HEADERS += \
    arc.h \
    compassfilter.h \
    declarativeview.h \
    mainwindow.h \
    orientationfilter.h \
    screensaverinhibiter.h

SOURCES += \
    main.cpp \
    compassfilter.cpp \
    declarativeview.cpp \
    mainwindow.cpp \
    screensaverinhibiter.cpp

OTHER_FILES += \
    qml/BorderDialog.qml \
    qml/Button.qml \
    qml/CalibrationView.qml \
    qml/Compass.qml \
    qml/InfoView.qml \
    qml/NoCompassNote.qml \
    qml/SettingsPane.qml \
    qml/Ui.qml \
    qml/settings.js \
    backup_registration.xml

RESOURCES = compass.qrc

symbian {
    TARGET = Compass
    TARGET.UID3 = 0xE4B73955
    TARGET.CAPABILITY = NetworkServices \
                        Location
    TARGET.EPOCHEAPSIZE = 0x100000 0x2000000
    TARGET.EPOCSTACKSIZE = 0x14000

    !contains(SYMBIAN_VERSION, Symbian3) {
        message(Symbian^1)

        # No OpenGL for Symbian^1
        QT -= opengl
        DEFINES += QT_NO_OPENGL
    }

    RESOURCES += rsc/symbian.qrc
    OTHER_FILES += \
        qml/symbian.qml \
        qml/pannablemap_symbian.qml

    # To lock the application to portrait orientation
    LIBS += -lcone -leikcore -lavkon
    ICON = icons/compass.svg

    # The beep is used in calibration, will install to application's private folder.
    sound.sources = beep.wav
    sound.path = !:/private/E4B73955

    # The backup and restore functionality, will install to application's private folder.
    backup.sources = backup_registration.xml
    backup.path = !:/private/E4B73955

    DEPLOYMENT += sound backup
}

# Harmattan
unix:!symbian:!maemo5 {
    message(Harmattan build)
    DEFINES += Q_WS_HARMATTAN

    RESOURCES += rsc/harmattan.qrc
    OTHER_FILES += \
        qml/harmattan.qml \
        qml/pannablemap_harmattan.qml


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
