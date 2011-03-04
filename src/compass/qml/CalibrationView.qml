import QtQuick 1.0
import CustomElements 1.0

Rectangle {
    id: view

    signal calibrated()

    property real calibrationLevel: 0

    width: 640; height: 360

    onCalibrationLevelChanged: {
        if(calibrationLevel >= 1.0) {
            calibrationCompletedAnimation.start()
        }
    }

    Image {
        id: shadow

        anchors {
            fill: scale
            margins: parent.width * -0.013
        }

        source: "images/scaleshadow.png"
        smooth: true
    }

    Image {
        id: scale

        anchors {
            top: parent.top; topMargin: 15
            bottom: parent.bottom; bottomMargin: 15
            right: parent.right; rightMargin: 15
        }

        width: height
        source: "images/scale100.png"
        smooth: true
        rotation: 0
    }

    Arc {
        anchors.fill: scale
        anchors.margins: 80

        opacity: 0.3
        color: "yellow"
        penWidth: 40
        startAngle: 90 * 16
        spanAngle: -view.calibrationLevel * 360 * 16

        Behavior on spanAngle { PropertyAnimation { duration: 1000 } }
    }

    Image {
        id: needle

        anchors.centerIn: scale
        width: height * 0.1214; height: scale.paintedHeight * 0.63
        source: "images/compassneedle.png"
        rotation: calibrationLevel * 360

        Behavior on rotation { PropertyAnimation { duration: 1000 } }

        smooth: true
    }

    Item {
        anchors {
            left: parent.left
            right: scale.left
            top: parent.top
            bottom: parent.bottom
            margins: 20
        }

        Image {
            anchors {
                top: parent.top
                bottom: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            smooth: true

            source: "images/calibration8.png"
        }

        Text {
            anchors {
                top: parent.verticalCenter; topMargin: 20
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            text: "Rotate the phone with figure of eight to calibrate the magnetometer sensor."
            color: "black"
            wrapMode: Text.WordWrap
            font.pixelSize: 25
        }
    }

    Rectangle {
        id: calibrationCompletedDialog

        anchors {
            fill: parent
            margins: 100
        }

        color: "black"
        border.color: "#303030"
        border.width: 2
        opacity: 0
        radius: 15

        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Calibration complete"
            font.pixelSize: parent.width * 0.1
        }
    }

    SequentialAnimation {
        id: calibrationCompletedAnimation

        PauseAnimation { duration: 1000 }

        PropertyAnimation {
            target: calibrationCompletedDialog
            property: "opacity"
            to: 1.0
            duration: 400
        }

        PauseAnimation { duration: 1000 }

        PropertyAnimation {
            target: view
            property: "opacity"
            to: 0.0
            duration: 1000
        }

        ScriptAction {
            script: {
                view.calibrated()
            }
        }
    }
}
