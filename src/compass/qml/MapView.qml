/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1


Page {
    id: mapView

    function showToolBar() {
        window.myTools = tools;
    }

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: Qt.quit()
        }

        ToolButton {
            id: gpsIndicator

            iconSource: "images/icon_gps.png"
            onClicked: map.panToCoordinate(map.hereCenter)
        }

        ToolButton {
            id: compassMode

            checkable: true
            iconSource: "images/icon_compassmode.png"
        }

        ToolButton {
            id: settingsToolButton

            checkable: true
            iconSource: "toolbar-settings"
        }
    }

    Component.onCompleted: {
        mapView.state = "MapMode";
        mobility.active = true;

        var initialCoordinate = settingsPane.readSettings();

        map.mapCenter = initialCoordinate;
        map.hereCenter.longitude = initialCoordinate.longitude;
        map.hereCenter.latitude = initialCoordinate.latitude;

        settingsPane.readRoute(map.route);

        // Extra step is required to set the custom toolbar
        showToolBar();
    }

    Mobility {
        id: mobility

        screenSaverInhibited: settingsPane.screenSaverInhibited;

        onCompass: {
            // Find if there is already calibration view open in page stack
            var calibrationView = mapView.pageStack.find(function(page) {
                return page.objectName === "calibrationView";
            });

            // If it does not exist and it should be shown, create and push it
            // to the stack.
            if (calibrationLevel < 1.0 && calibrationView === null) {
                calibrationView = mapView.pageStack.push(
                            Qt.resolvedUrl("CalibrationView.qml"));
            }

            // If the calibration view exists, set the calibration level to it.
            if (calibrationView !== null) {
                calibrationView.setCalibrationLevel(calibrationLevel);
            }

            compass.azimuth = azimuth;
        }

        onPosition: {
            console.log("Position: " + coordinate.latitude +
                        ", " + coordinate.longitude +
                        " accuracy " + accuracyInMeters + " m");

            settingsPane.saveInitialCoordinate(coordinate);

            if (settingsPane.trackingOn === true && accuracyInMeters < 75) {
                // The recording is on and the GPS position is accurate
                // enough.
                settingsPane.saveRouteCoordinate(coordinate, time, accuracyInMeters);
                map.addRoute(coordinate);
            }

            map.moveHereToCoordinate(coordinate, accuracyInMeters);
        }
    }

    Image {
        id: background

        anchors.fill: parent

        source: "images/compass_back.png"
        fillMode: Image.Tile
    }

    PannableMap {
        id: map

        anchors.fill: parent

        satelliteMap: settingsPane.satelliteMap
    }

    CompassPlate {
        id: compass

        opacity: 0

        // Turns automatically the bearing to the map north
        onUserRotatedCompass: compass.bearing = -compass.rotation
        bearingRotable: true
    }

    SettingsPane {
        id: settingsPane

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom; bottomMargin: parent.tools.height + 8
        }

        opacity: settingsToolButton.checked ? 1.0 : 0.0
        onClearRoute: map.clearRoute()
    }

    Button {
        id: infoButton

        anchors {
            top: parent.top
            right: parent.right
            margins: 5
        }

        iconSource: "images/icon_info.png"
        opacity: settingsPane.opacity
        onClicked: {
            if (mapView.pageStack.busy === false) {
                mapView.pageStack.push(Qt.resolvedUrl("InfoView.qml"));
            }
        }
    }

    states: [
        State {
            when: !compassMode.checked
            name: "MapMode"
            PropertyChanges { target: map; opacity: 1.0 }
            PropertyChanges {
                target: compass
                opacity: 1.0
                width: 0.483607 * height; height: 0.40625 * mapView.height
                movable: true
                compassRotable: true
            }
        },
        State {
            when: compassMode.checked
            name: "TrackMode"
            PropertyChanges { target: map; opacity: 0 }
            PropertyChanges {
                target: compass
                opacity: 1.0; rotation: 0
                width: 0.483607 * height
                height: mapView.height - mapView.tools.height
                x: (mapView.width - width) / 2; y: 0;
                movable: false
                compassRotable: false
            }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "x,y,width,height,opacity"
            duration: 500
            easing.type: Easing.InOutCirc
        }

        RotationAnimation {
            property: "rotation"
            duration: 500
            easing.type: Easing.InOutCirc
            direction:  RotationAnimation.Shortest
        }
    }
}
