import QtQuick 1.1
import QtMobility.sensors 1.2
import QtMobility.location 1.2

Item {
    id: container

    signal compass(real azimuth, real calibrationLevel);
    signal position(variant time, variant coordinate, real accuracyInMeters);

    // Inhibits screen saver if true
    property bool screenSaverInhibited: false

    // Activates compass sensor and position source
    property bool active: false

    /*!
      Creates dynamically the ScreenSaver element to inhibit the screensaver.
    */
    onScreenSaverInhibitedChanged: {
        if (screenSaverInhibited) {
            console.log("Creating the ScreenSaver element");

            privateImplementation.inhibiter = Qt.createQmlObject(
                        'import QtQuick 1.1; import QtMobility.systeminfo 1.1; ScreenSaver {}',
                         privateImplementation,
                        "Dynamic ScreenSaver element");
            if (privateImplementation.inhibiter == null) {
                console.log("Failed to create ScreenSaver element!");
                return;
            }

            if (privateImplementation.inhibiter.setScreenSaverInhibit() === false) {
                console.log("Failed to set the screen saver inhibiter");
            }
        }
        else {
            console.log("Destroying the ScreenSaver element");

            if (privateImplementation.inhibiter != null) {
                privateImplementation.inhibiter.destroy();
                privateImplementation.inhibiter = null;
            }
        }
    }

    QtObject {
        id: privateImplementation

        property variant inhibiter: null
    }

    Compass {
        id: compassSensor

        active: container.active

        onReadingChanged: {
            container.compass(reading.azimuth,
                              reading.calibrationLevel);
        }
    }

    PositionSource {
        id: positionSource

        active: container.active
        updateInterval: 5000

        onPositionChanged: {
            var accuracyInMeters = Math.max(position.horizontalAccuracy,
                                            position.verticalAccuracy);

            container.position(position.timestamp, position.coordinate,
                               accuracyInMeters);
        }
    }
}
