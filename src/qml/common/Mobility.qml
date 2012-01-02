import QtQuick 1.1
import QtMobility.sensors 1.2
import QtMobility.location 1.2

Item {
    id: container

    signal compass(real azimuth, real calibrationLevel);
    signal position(variant coordinate, variant time, real accuracyInMeters);
    signal noCompassDetected();

    // Inhibits screen saver if true
    property bool screenSaverInhibited: false

    // Activates compass sensor and position source
    property bool active: false

    // Starts the compass sensor and position source
    function startSensors() {
        noCompassCheck.running = true;
        compassSensor.active = true;
        positionSource.active = true;
    }

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

    Timer {
        id: noCompassCheck

        property bool compassReadingReceived: false

        running: false
        interval: 5000
        onTriggered: {
            if (!compassReadingReceived) {
                // Compass reading hasn't been received from the sensor
                // in 5 seconds.
                container.noCompassDetected();
                running = false;
            }
        }
    }

    Compass {
        id: compassSensor

        active: false
        onReadingChanged: {
            noCompassCheck.compassReadingReceived = true;
            container.compass(reading.azimuth,
                              reading.calibrationLevel);
        }
    }

    PositionSource {
        id: positionSource

        active: false
        updateInterval: 5000

        onPositionChanged: {
            var accuracyInMeters = Math.max(position.horizontalAccuracy,
                                            position.verticalAccuracy);

            container.position(position.coordinate,
                               position.timestamp,
                               accuracyInMeters);
        }
    }
}
