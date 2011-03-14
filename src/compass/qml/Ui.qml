import QtQuick 1.0

Rectangle {
    id: ui

    property real northdeg: 0
    property bool portrait: true
    property bool pinching: false

    signal inhibitScreensaver(variant inhibit);

    function orientationChanged(orientation) {
        if(orientation == 1) {
            ui.portrait = true
        }
        else if(orientation == 4) {
            ui.portrait = false
        }
    }

    function handleAzimuth(azimuth, calLevel) {
        calibrationView.calibrationLevel = calLevel

        if(calLevel < 1.0) {
            ui.state = "CalibrationMode"
        }

        ui.northdeg = -azimuth
    }

    function scaleChanged(scale) {
        pinching = true

        if(ui.state != "MapMode") {
            return
        }

        map.scale = Math.pow(2, scale - map.zoomLevel)
        map.scale = map.scale
    }

    function scaleChangedEnd(scale) {
        pinching = false
        map.scale = 1

        if(ui.state != "MapMode") {
            return
        }

        var zoom = Math.round(scale)

        if(zoom > map.maximumZoomLevel) {
            zoom = map.maximumZoomLevel
        }
        else if(scale < map.minimumZoomLevel) {
            zoom = map.minimumZoomLevel
        }

        map.zoomLevel = zoom
    }

    function position(time, latitude, longitude, accuracyInMeters) {
        console.log("Setting coordinates: " + latitude + ", "
                    + longitude, " time: " + time
                    + " accuracy: " + accuracyInMeters)

        if(time != 0 && accuracyInMeters < 100) {
            // The GPS position is accurate enough and the position
            // is not the last known position, we can save this
            // to our route.
            settingsPane.saveRouteCoordinate(time, latitude, longitude, accuracyInMeters)
            map.addRoute(latitude, longitude)
        }

        if(time == 0) {
            // This is last known position and the application is just starting
            map.mapCenter.latitude = latitude
            map.mapCenter.longitude = longitude

            map.hereCenter.latitude = latitude
            map.hereCenter.longitude = longitude
            map.hereAccuracy = accuracyInMeters
        }
        else if(ui.state == "TrackMode") {
            map.mapCenter.latitude = latitude
            map.mapCenter.longitude = longitude

            map.hereCenter.latitude = latitude
            map.hereCenter.longitude = longitude
            map.hereAccuracy = accuracyInMeters
        }
        else {
            map.hereCenter.latitude = latitude
            map.hereCenter.longitude = longitude
            map.hereAccuracy = accuracyInMeters
        }
    }

    anchors.fill: parent
    width: 640; height: 360
    color: "#f8f8f0"

    Component.onCompleted: ui.state = "CalibrationMode"

    PannableMap {
        id: map

        anchors.fill: parent
        satelliteMap: settingsPane.satelliteMap

        panEnable: {
            if(ui.state != "MapMode") {
                return false
            }

            if(ui.pinching) {
                return false
            }

            return true
        }
    }

    CalibrationView {
        id: calibrationView

        anchors.fill: parent
        opacity: 0
        onCalibrated: ui.state = "MapMode"
    }

    Compass {
        id: compass

        property real rotationOnMap: 0

        opacity: 0

        onRotationChanged: {
            if(settingsPane.autoNorthInMap && ui.state == "MapMode") {
                compass.bearing = -compass.rotation
            }
        }

        compassRotable: ui.state == "MapMode" ? true : false

        bearingRotable: {
            if(ui.state == "MapMode" && !settingsPane.autoNorthInMap) {
                return true
            }
            if(ui.state == "TrackMode" && settingsPane.bearingTurnInTrackMode) {
                return true
            }
            return false
        }
    }

    SettingsPane {
        id: settingsPane

        property bool shown: false

        onScreenSaverInhibitedChanged: {
            console.log("Signalling inhibitScreensaver: " + screenSaverInhibited)
            ui.inhibitScreensaver(screenSaverInhibited)
        }

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: shown ? -10 : -width - border.width / 2
        }

        width: parent.width * 0.5

        Behavior on anchors.leftMargin { PropertyAnimation { easing.type: Easing.InOutQuad } }
    }

    InfoView {
        id: infoView

        portrait: ui.portrait

        anchors {
            top: parent.top; topMargin: 2
            bottom: buttonColumn.top; bottomMargin: 2
            left: parent.left; leftMargin: 2
            right: parent.right; rightMargin: 2
        }
    }

    Item {
        id: buttonColumn

        property real buttonWidth: width / 6

        anchors {
            bottom: parent.bottom
            left: parent.left; leftMargin: 10
            right: parent.right; rightMargin: 10
        }

        height: mapModeButton.height

        Button {
            id: mapModeButton

            anchors.left: parent.left

            width: parent.buttonWidth
            portrait: ui.portrait
            opacity: 0.0

            text: ui.state == "TrackMode" ? "To Map\nmode" : "To Track\n mode"
            buttonColor: "#80000000"
            onClicked: {
                if(ui.state == "MapMode") {
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
                leftMargin: (parent.width - 4 * buttonColumn.buttonWidth) / 3
            }

            width: buttonColumn.buttonWidth
            portrait: ui.portrait
            opacity: 0.0

            text: "Settings"
            buttonColor: settingsPane.shown ? "#8001A300" : "#80000000"
            onClicked: {
                settingsPane.shown = !settingsPane.shown
                if(settingsPane.shown) {
                    infoView.shown = false
                }
            }
        }


        Button {
            id: infoScreenButton

            anchors {
                left: settingsButton.right
                leftMargin: (parent.width - 4 * buttonColumn.buttonWidth) / 3
            }

            width: parent.buttonWidth
            portrait: ui.portrait
            opacity: 0.0

            text: "Info"
            buttonColor: infoView.shown ? "#8001A300" : "#80000000"
            onClicked: {
                infoView.shown = !infoView.shown
                if(infoView.shown) {
                    settingsPane.shown = false
                }
            }
        }

        Button {
            id: closeButton

            anchors.right: parent.right

            width: parent.buttonWidth
            portrait: ui.portrait

            onClicked: Qt.quit()

            icon: "images/closex.png"
        }
    }

    states: [
        State {
            name: "MapMode"
            PropertyChanges { target: map; opacity: 1.0 }
            PropertyChanges { target: compass; opacity: 1.0; width: 0.453125 * height; height: 260; movable: true }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: mapModeButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 1 }
            PropertyChanges { target: infoScreenButton; opacity: 1 }
        },
        State {
            name: "TrackMode"
            PropertyChanges { target: map; opacity: 0 }
            PropertyChanges { target: compass; opacity: 1.0; rotation: 0; x: 33; y: 0; width: 295; height: 610; movable: false }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: mapModeButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
            StateChangeScript {
                script: {
                    ui.portrait = true
                    settingsPane.shown = false
                    infoView.shown = false
                }
            }
        },
        State {
            name: "CalibrationMode"
            PropertyChanges { target: compass; opacity: 0 }
            PropertyChanges { target: calibrationView; opacity: 1 }
            PropertyChanges { target: mapModeButton; opacity: 0 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
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
