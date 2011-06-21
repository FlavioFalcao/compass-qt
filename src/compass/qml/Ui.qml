/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

AppWindow {
    id: ui

    property real northdeg: 0
    property bool portrait: true
    property bool pinching: false

    property bool screenSaverInhibited: settingsPane.screenSaverInhibited

    signal inhibitScreensaver(variant inhibit);

    function orientationChanged(orientation) {
        if (orientation == 1) {
            ui.portrait = true
        }
        else if (orientation == 4) {
            ui.portrait = false
        }
    }

    function handleAzimuth(azimuth, calLevel) {
        calibrationView.calibrationLevel = calLevel

        if (calLevel < 1.0) {
            ui.state = "CalibrationMode"
        }

        ui.northdeg = -azimuth
    }

    function scaleChanged(scale) {
        pinching = true

        if (ui.state != "MapMode") {
            return
        }

        map.scale = Math.pow(2, scale - map.zoomLevel)
    }

    function scaleChangedEnd(scale) {
        pinching = false
        map.scale = 1

        if (ui.state != "MapMode") {
            return
        }

        var zoom = Math.round(scale)

        if (zoom > map.maximumZoomLevel) {
            zoom = map.maximumZoomLevel
        }
        else if (scale < map.minimumZoomLevel) {
            zoom = map.minimumZoomLevel
        }

        map.zoomLevel = zoom
    }

    function position(time, latitude, longitude, accuracyInMeters) {
        // Stop the animation of GPS indicator
        gpsIndicator.animate(false)

        if (time != 0 && accuracyInMeters < 100) {
            // The GPS position is accurate enough and the position
            // is not the last known position, we can save this
            // to our route.

            /*
            settingsPane.saveRouteCoordinate(time, latitude, longitude,
                                             accuracyInMeters)
            map.addRoute(latitude, longitude)
            */
        }

        if (time == 0) {
            // This is last known position and the application is just starting
            // set map to show that position
            console.log("Setting the last known position to:" + latitude + ", " + longitude)
            map.mapCenter.latitude = latitude
            map.mapCenter.longitude = longitude
        }

        map.moveHereToCoordinate(latitude, longitude, accuracyInMeters)
    }

    function positionTimeout() {
        // No signal from GPS, start the animation of GPS indicator
        gpsIndicator.animate(true)
    }

    /**
     * Displays a warning note informing the user that the compass sensor
     * does not work.
     */
    function displayNoCompassNote()
    {
        console.debug("Ui.qml: displayNoCompassNote()");
        noCompassNoteLoader.source = "NoCompassNote.qml";
    }

    Component.onCompleted: {
        settingsPane.readSettings()
        ui.state = "MapMode"
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
        panEnable: ui.state != "MapMode" || ui.pinching ? false : true
    }

    CalibrationView {
        id: calibrationView

        anchors.fill: parent
        opacity: 0
        useFeedbackEffect: settingsPane.feedbackEnabled
        onCalibrated: {
            ui.state = "MapMode"
            // Most likely the user is holding the phone on portrait
            // while calibrating, lets make the UI initially to portrait
            // even it might be physically on landscape position
            ui.portrait = true
        }
    }

    Compass {
        id: compass

        property real rotationOnMap: 0

        opacity: 0

        onUserRotatedCompass: {
            if(settingsPane.autoNorthInMap)
                compass.bearing = -compass.rotation
        }
        compassRotable: ui.state == "MapMode" ? true : false
        bearingRotable: {
            if (ui.state == "MapMode" && !settingsPane.autoNorthInMap) {
                return true
            }
            if (ui.state == "TrackMode"
                    && settingsPane.bearingTurnInTrackMode) {
                return true
            }
            return false
        }
    }

    Button {
        id: gpsIndicator

        function animate(animating) {
            if (animating) {
                animationPlaying = true
            }
            else {
                animationPlaying = false
            }
        }

        anchors {
            left: parent.left; leftMargin: 10
            top: parent.top
        }

        width: buttonRow.buttonWidth; height: buttonRow.buttonHeight
        upsideDown: true
        animationPlaying: true

        portrait: ui.portrait
        icon: "images/icon_gps.png"

        onClicked: map.panToCoordinate(map.hereCenter)
    }

    Item {
        id: buttonRow

        property real buttonWidth: background.width * 0.2
        property real buttonHeight: background.height * 0.09375

        anchors {
            bottom: parent.bottom
            left: parent.left; leftMargin: 10
            right: parent.right; rightMargin: 10
        }

        height: mapModeButton.height

        Button {
            id: mapModeButton

            anchors.left: parent.left

            width: parent.buttonWidth; height: parent.buttonHeight
            portrait: ui.portrait

            icon: ui.state == "TrackMode" ? "images/icon_mapmode.png"
                                          : "images/icon_compassmode.png"
            buttonColor: "#80000000"
            onClicked: {
                if (ui.state == "MapMode") {
                    ui.state = "TrackMode"
                }
                else {
                    ui.state = "MapMode"
                }
            }
        }

        Button {
            id: settingsButton

            anchors {
                left: mapModeButton.right
                leftMargin: (parent.width - 4 * buttonRow.buttonWidth) / 3
            }

            width: buttonRow.buttonWidth; height: parent.buttonHeight
            portrait: ui.portrait

            icon: "images/icon_settings.png"
            buttonColor: settingsPane.shown ? "#8001A300" : "#80000000"
            onClicked: {
                settingsPane.shown = !settingsPane.shown
                if (settingsPane.shown) {
                    infoView.shown = false
                }
            }
        }


        Button {
            id: infoScreenButton

            anchors {
                left: settingsButton.right
                leftMargin: (parent.width - 4 * buttonRow.buttonWidth) / 3
            }

            width: parent.buttonWidth; height: parent.buttonHeight
            portrait: ui.portrait

            icon: "images/icon_info.png"
            buttonColor: infoView.shown ? "#8001A300" : "#80000000"
            onClicked: {
                infoView.shown = !infoView.shown
                if (infoView.shown) {
                    settingsPane.shown = false
                }
            }
        }

        Button {
            id: closeButton

            visible: ui.exitButtonVisible
            anchors.right: parent.right

            width: parent.buttonWidth; height: parent.buttonHeight
            portrait: ui.portrait
            icon: "images/icon_closex.png"

            onClicked: Qt.quit()
        }
    }

    SettingsPane {
        id: settingsPane

        portrait: ui.portrait

        onScreenSaverInhibitedChanged: {
            ui.inhibitScreensaver(screenSaverInhibited)
        }

        x: shown ? 0 : -width
        width: parent.width; height: parent.height - buttonRow.height

        Behavior on x {
            PropertyAnimation {
                easing.type: Easing.InOutCubic
                duration: 250
            }
        }
    }

    InfoView {
        id: infoView

        portrait: ui.portrait

        x: shown ? 0 : width
        width: parent.width; height: parent.height - buttonRow.height

        Behavior on x {
            PropertyAnimation {
                easing.type: Easing.InOutCubic
                duration: 250
            }
        }
    }

    Loader {
        id: noCompassNoteLoader

        width: parent.width
        height: parent.height - buttonRow.height
    }

    states: [
        State {
            name: "MapMode"
            PropertyChanges { target: map; opacity: 1.0 }
            PropertyChanges {
                target: compass; opacity: 1.0
                width: 0.483607 * height; height: 0.40625 * background.height
                movable: true
            }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: mapModeButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 1 }
            PropertyChanges { target: infoScreenButton; opacity: 1 }
            PropertyChanges { target: gpsIndicator; opacity: 1 }
        },
        State {
            name: "TrackMode"
            PropertyChanges { target: settingsButton; enabled: false }
            PropertyChanges { target: infoScreenButton; enabled: false }
            PropertyChanges { target: map; opacity: 0 }
            PropertyChanges {
                target: compass; opacity: 1.0; rotation: 0
                width: 0.483607 * height; height: background.height * 0.953125
                x: (background.width - width) / 2; y: 0;
                movable: false
            }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: mapModeButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
            PropertyChanges { target: gpsIndicator; opacity: 0 }
            StateChangeScript {
                script: {
                    settingsPane.shown = false
                    infoView.shown = false
                }
            }
        },
        State {
            name: "CalibrationMode"
            PropertyChanges { target: map; opacity: 0 }
            PropertyChanges { target: compass; opacity: 0 }
            PropertyChanges { target: calibrationView; opacity: 1 }
            PropertyChanges { target: mapModeButton; opacity: 0 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
            PropertyChanges { target: gpsIndicator; opacity: 0 }
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
