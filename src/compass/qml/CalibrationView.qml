/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import QtMobility.feedback 1.1
import QtMultimediaKit 1.1
import CustomElements 1.0

Rectangle {
    id: view

    signal calibrated()

    property bool portrait
    property real calibrationLevel: 0
    property bool useVibraEffect

    width: 640; height: 360

    onCalibrationLevelChanged: {
        if(calibrationLevel >= 1.0) {
            calibrationCompletedAnimation.start()
        }
        if(useVibraEffect) {
            vibraEffect.running = true
        }
    }

    Audio {
        id: audioEffect
        source: "file:///c:/System/compass/beep.wav"
        volume: 0.5
    }

    HapticsEffect {
        id: vibraEffect

        attackIntensity: 0.1
        attackTime: 50
        intensity: Math.min(0.8, view.calibrationLevel + 0.2)
        duration: 100
        fadeTime: 50
        fadeIntensity: 0.1
        running: false
    }

    Timer {
        interval: 700 - view.calibrationLevel * 600
        running: view.calibrationLevel < 1.0
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (view.useVibraEffect) {
                vibraEffect.running = true
            }
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
            bottom: parent.bottom; bottomMargin: 35
            left: parent.left; leftMargin: 15
            right: parent.right; rightMargin: 15
        }

        height: width
        source: "images/scale100.png"
        smooth: true
    }

    Arc {
        anchors {
            fill: scale
            margins: 80
        }

        opacity: 0.5

        startColor: "red"
        endColor: "lawngreen"
        penWidth: 45
        startAngle: 0
        spanAngle: needle.rotation
    }

    Image {
        id: needle

        anchors.centerIn: scale
        width: height * 0.1214; height: scale.paintedHeight * 0.63
        source: "images/compassneedle.png"
        rotation: calibrationLevel * 360

        Behavior on rotation { PropertyAnimation { duration: 750 } }

        smooth: true
    }

    Item {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: scale.top
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
            fillMode: Image.PreserveAspectFit

            source: "images/calibration8.png"
        }

        Text {
            anchors {
                top: parent.verticalCenter; topMargin: 20
                bottom: parent.bottom
                left: parent.left
                right: parent.right
            }

            text: "Rotate the phone with figure of eight to calibrate " +
                  "the magnetometer sensor."
            color: "black"
            wrapMode: Text.WordWrap
            font.pixelSize: 25
        }
    }

    Rectangle {
        id: calibrationCompletedDialog

        anchors.centerIn: parent

        width: parent.width * 0.8
        height: parent.height * 0.2

        color: "black"
        border.color: "#303030"
        border.width: 2
        opacity: 0
        radius: 15

        Text {
            anchors.centerIn: parent
            color: "white"
            text: "Calibration\ncomplete"
            font.pixelSize: parent.height * 0.3
        }
    }

    SequentialAnimation {
        id: calibrationCompletedAnimation

        PauseAnimation { duration: 1000 }

        ScriptAction { script: audioEffect.play() }

        PropertyAnimation {
            target: calibrationCompletedDialog
            property: "opacity"
            to: 0.8
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
                calibrationCompletedDialog.opacity = 0
            }
        }
    }
}
