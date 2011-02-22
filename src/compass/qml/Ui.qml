import Qt 4.7
import QtWebKit 1.0

Item {
    id: ui

    property real northdeg: 45

    function handleAzimuth(azimuth, calLevel) {
        calibrationView.calibrationLevel = calLevel

        if(calLevel < 1.0) {
            //ui.state = "CalibrationMode"
        }

        ui.northdeg = -azimuth
    }

    function scaleChanged(scale, pos) {
        /*
        map.xorig = pos.x
        map.yorig = pos.y
        map.scaleFactor = scale
        */
    }

    function toggleMode() {
        if(state == "NavigationMode")
            state = "MapMode"
        else
            state = "NavigationMode"
    }

    width: 640; height: 360
    anchors.fill: parent

    CalibrationView {
        id: calibrationView

        opacity: 0
        anchors.fill: parent
        onCalibrated: ui.state = "NavigationMode"
    }

    Compass {
        id: compass
    }

    SettingsPane {
        id: settingsPane

        property bool shown: false

        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left; leftMargin: shown ? -10 : -width - 3
        }

        width: parent.width * 0.3

        Behavior on anchors.leftMargin { PropertyAnimation { easing.type: Easing.InOutQuart } }
    }

    Button {
        id: infoScreen

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

    Button {
        id: settingsButton

        anchors {
            left: parent.left; leftMargin: 5
            bottom: parent.bottom; bottomMargin: 5
        }

        source: "images/icontool.png"
        onClicked: settingsPane.shown = !settingsPane.shown
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

    states: [
        State {
            name: "MapMode"
            PropertyChanges { target: compass; width: 260; height: 0.45625 * width; rotable: true; movable: true }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: toggleButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 1 }
        },
        State {
            name: "NavigationMode"
            PropertyChanges { target: compass; rotation: 0; x: 0; y: 34; width: 640; height: 292; rotable: false; movable: false }
            PropertyChanges { target: calibrationView; opacity: 0 }
            PropertyChanges { target: toggleButton; opacity: 1 }
            PropertyChanges { target: settingsButton; opacity: 0 }
            StateChangeScript { script: settingsPane.shown = false }
        },
        State {
            name: "CalibrationMode"
            PropertyChanges { target: compass; opacity: 0 }
            PropertyChanges { target: calibrationView; opacity: 1 }
            PropertyChanges { target: toggleButton; opacity: 0 }
            PropertyChanges { target: flickableMap; opacity: 0 }
            PropertyChanges { target: settingsButton; opacity: 0 }
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
