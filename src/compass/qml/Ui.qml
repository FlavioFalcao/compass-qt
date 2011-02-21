import Qt 4.7
import QtWebKit 1.0

Rectangle {
    id: ui

    property real northdeg: 45

    function handleAzimuth(azimuth, calLevel) {
        calibrationView.calibrationLevel = calLevel

        if(calLevel < 1.0) {
            ui.state = ""
        }

        ui.northdeg = -azimuth
    }

    function toggleMode() {
        if(state == "NavigationMode")
            state = "MapMode"
        else
            state = "NavigationMode"
    }

    width: 640; height: 360
    anchors.fill: parent
    color: "gray"

    Flickable {
        id: flickableMap

        anchors.fill: parent; anchors.margins: 30
        contentWidth: map.width
        contentHeight: map.height
        clip: true

        Image {
            id: map

            source: "images/innovamap.jpg"
        }
    }

    CalibrationView {
        id: calibrationView

        opacity: 0
        anchors.fill: parent
        calibrationLevel: ui.calLevel
        onCalibrated: ui.state = "NavigationMode"
    }

    Compass {
        id: compass
    }

    Image {
        id: toggleButton
        anchors {
            right: parent.right; rightMargin: 5
            bottom: parent.bottom; bottomMargin: 5
        }

        opacity: 0.8
        source: ui.state == "MapMode"
                ? "images/iconcompass.png"
                : "images/iconovimaps.png"
        smooth: true

        Behavior on scale { PropertyAnimation { duration: 50 } }

        MouseArea {
            anchors.fill: parent
            onClicked: ui.toggleMode()
            onPressed: toggleButton.scale = 0.9
            onReleased: toggleButton.scale = 1.0
            scale: 3
        }
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

        Image {
            id: closeButton

            anchors.centerIn: parent

            source: "images/exit.png"
            smooth: true

            Behavior on scale { PropertyAnimation { duration: 50 } }

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
                onPressed: closeButton.scale = 0.9
                onReleased: closeButton.scale = 1.0
                scale: 3
            }
        }
    }

    states: [
        State {
            name: "MapMode"
            PropertyChanges { target: compass; width: 260; height: 0.45625 * width; rotable: true; movable: true }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: toggleButton; opacity: 1 }
            PropertyChanges { target: flickableMap; opacity: 1 }
        },
        State {
            name: "NavigationMode"
            PropertyChanges { target: compass; rotation: 0; x: 0; y: 34; width: 640; height: 292; rotable: false; movable: false }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: toggleButton; opacity: 1 }
            PropertyChanges { target: flickableMap; opacity: 0.1 }
        },
        State {
            name: "CalibrationMode"
            PropertyChanges { target: compass; opacity: 0 }
            PropertyChanges { target: calibrationView; opacity: 1 }
            PropertyChanges { target: toggleButton; opacity: 0 }
            PropertyChanges { target: flickableMap; opacity: 0 }
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
