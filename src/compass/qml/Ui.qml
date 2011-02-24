import QtQuick 1.0
import QtMobility.location 1.1

Rectangle {
    id: ui

    property real northdeg: 45

    function handleAzimuth(azimuth, calLevel) {
        calibrationView.calibrationLevel = calLevel

        if(calLevel < 1.0) {
            ui.state = "CalibrationMode"
        }

        ui.northdeg = -azimuth
    }

    function scaleChanged(scale) {
        if(scale > map.maximumZoomLevel || scale < map.minimumZoomLevel) {
            return
        }

        map.zoomLevel = Math.floor(scale)
    }

    function toggleMode() {
        if(state == "NavigationMode")
            state = "MapMode"
        else
            state = "NavigationMode"
    }

    width: 640; height: 360
    color: "gray"
    anchors.fill: parent

    Map {
        id: map

        plugin : Plugin { name : "nokia" }
        size.width: parent.width
        size.height: parent.height
        zoomLevel: 8
        connectivityMode: Map.HybridMode
        center: Coordinate {
            latitude: 62.2404611
            longitude: 25.7614159
        }
    }

    MouseArea {
        anchors.fill: parent

        property bool mouseDown: false
        property int lastX: -1
        property int lastY: -1

        hoverEnabled: true
        onPressed: {
            mouseDown = true
            lastX = mouse.x
            lastY = mouse.y
        }

        onReleased: {
            mouseDown = false
            lastX = -1
            lastY = -1
        }

        onPositionChanged: {
            if (mouseDown) {
                var dx = mouse.x - lastX
                var dy = mouse.y - lastY
                map.pan(-dx, -dy)
                lastX = mouse.x
                lastY = mouse.y
            }
        }
    }

    CalibrationView {
        id: calibrationView

        opacity: 0
        anchors.fill: parent
        onCalibrated: ui.state = "NavigationMode"
    }

    Compass {
        id: compass
    }

    Button {
        id: infoScreenButton

        anchors {
            left: parent.left; leftMargin: 5
            top: parent.top; topMargin: 5
        }

        source: "images/iconinfo.png"
        //onClicked:
    }


    Button {
        id: toggleButton

        anchors {
            right: parent.right; rightMargin: 5
            bottom: parent.bottom; bottomMargin: 5
        }

        source: ui.state == "MapMode"
                ? "images/iconcompass.png"
                : "images/iconovimaps.png"

        onClicked: ui.toggleMode()
    }

    Rectangle {

        anchors {
            right: parent.right; rightMargin: 5
            top: parent.top; topMargin: 5
        }

        width: 40; height: 40

        color: "#303000"
        opacity: 0.8
        radius: 6

        Button {
            id: closeButton

            anchors.centerIn: parent
            source: "images/exit.png"
            onClicked: Qt.quit()
        }
    }

    SettingsPane {
        id: settingsPane

        property bool shown: false

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            leftMargin: shown ? -10 : -width - border.width / 2
        }

        width: parent.width * 0.3

        Behavior on anchors.leftMargin { PropertyAnimation { easing.type: Easing.InOutQuad } }
    }

    Button {
        id: settingsButton

        anchors {
            left: settingsPane.right; leftMargin: 5
            bottom: parent.bottom; bottomMargin: 5
        }

        source: "images/icontool.png"
        onClicked: settingsPane.shown = !settingsPane.shown
    }

    states: [
        State {
            name: "MapMode"
            PropertyChanges { target: compass; width: 260; height: 0.45625 * width; rotable: true; movable: true }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: toggleButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 1 }
            PropertyChanges { target: infoScreenButton; opacity: 1 }
        },
        State {
            name: "NavigationMode"
            PropertyChanges { target: compass; rotation: 0; x: 0; y: 34; width: 640; height: 292; rotable: false; movable: false }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: toggleButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
            PropertyChanges { target: map; opacity: 0.2 }
            StateChangeScript { script: settingsPane.shown = false }
        },
        State {
            name: "CalibrationMode"
            PropertyChanges { target: compass; opacity: 0 }
            PropertyChanges { target: calibrationView; opacity: 1 }
            PropertyChanges { target: toggleButton; opacity: 0 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            PropertyChanges { target: infoScreenButton; opacity: 0 }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "x,y,width,height,rotation,opacity"
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
