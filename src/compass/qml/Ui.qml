import QtQuick 1.0

Rectangle {
    id: ui

    property real northdeg: 45
    property bool portrait: false
    property bool pinching: false

    signal inhibitScreensaver(variant inhibit);

    function orientationChanged(orientation) {
        console.log("Orientation: " + portrait);

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

    function position(latitude, longitude) {
        console.log("Setting coordinates: " + latitude + ", " + longitude)

        if(ui.state == "TrackMode") {
            map.mapCenter.latitude = latitude
            map.mapCenter.longitude = longitude

            map.hereCenter.latitude = latitude
            map.hereCenter.longitude = longitude
        }
        else {
            map.hereCenter.latitude = latitude
            map.hereCenter.longitude = longitude
        }
    }

    anchors.fill: parent
    width: 640; height: 360
    color: "gray"

    PannableMap {
        id: map

        mapType: settingsPane.mapMode
        anchors.fill: parent

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
        onCalibrated: ui.state = "TrackMode"
    }

    Compass {
        id: compass

        property real rotationOnMap: 0

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

        width: parent.width * 0.3

        Behavior on anchors.leftMargin { PropertyAnimation { easing.type: Easing.InOutQuad } }
    }

    InfoView {
        id: infoView

        anchors {
            fill: parent
            leftMargin: 10
            rightMargin: 10
            topMargin: 30
            bottomMargin: 30
        }
    }

    Button {
        id: navigationModeButton

        anchors {
            right: parent.right; rightMargin: 10
            bottom: parent.bottom
        }

        text: "Track\nmode"
        buttonColor: ui.state == "TrackMode" ? "#8001A300" : "#80000000"
        onClicked: {
            if(ui.state != "TrackMode") {
                compass.rotationOnMap = compass.rotation
            }
            ui.state = "TrackMode"
        }
    }

    Button {
        id: mapModeButton

        anchors {
            right: navigationModeButton.left; rightMargin: 20
            bottom: parent.bottom
        }

        text: "Map\nmode"
        buttonColor: ui.state == "MapMode" ? "#8001A300" : "#80000000"
        onClicked: ui.state = "MapMode"
    }

    Button {
        id: closeButton

        anchors {
            right: parent.right; rightMargin: 10
            top: parent.top
        }

        width: 60

        upSideDown: true
        onClicked: Qt.quit()

        Image {
            anchors.centerIn: parent
            source: "images/closex.png"
        }
    }

    Button {
        id: settingsButton

        anchors {
            left: parent.left; leftMargin: 5
            bottom: parent.bottom
        }

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
            left: settingsButton.right; leftMargin: 20
            bottom: parent.bottom
        }

        text: "Info"
        buttonColor: infoView.shown ? "#8001A300" : "#80000000"
        onClicked: {
            infoView.shown = !infoView.shown
            if(infoView.shown) {
                settingsPane.shown = false
            }
        }
    }

    states: [
        State {
            name: "MapMode"
            PropertyChanges { target: map; opacity: 1.0; rotation: 0 }
            PropertyChanges { target: compass; width: 260; height: 0.453125 * width; movable: true }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: mapModeButton; opacity: 1 }
            PropertyChanges { target: navigationModeButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 1 }
            PropertyChanges { target: infoScreenButton; opacity: 1 }
        },
        State {
            name: "TrackMode"
            PropertyChanges { target: map; opacity: 1.0; rotation: -compass.rotationOnMap }
            PropertyChanges { target: compass; rotation: 0; x: 0; y: 34; width: 640; height: 290; movable: false }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: mapModeButton; opacity: 1 }
            PropertyChanges { target: navigationModeButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
            StateChangeScript {
                script: {

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
            PropertyChanges { target: navigationModeButton; opacity: 0 }
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
