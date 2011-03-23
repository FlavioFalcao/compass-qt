/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

Item {
    id: button

    property bool portrait: false
    property alias text: text.text
    property color buttonColor: "#AA000000"
    property alias icon: icon.source
    property alias animationPlaying: icon.playing
    property bool upsideDown: false

    signal clicked()

    width: 60; height: 60

    Rectangle {
        anchors {
            fill: parent
            bottomMargin: button.upsideDown ? 0 : -10
            topMargin: button.upsideDown ? -10 : 0
        }

        radius: 8
        smooth: true
        gradient: normalGradient

        Gradient {
            id: normalGradient

            GradientStop {
                position: 0.0
                color: Qt.lighter(button.buttonColor, 1.8)
            }
            GradientStop {
                position: 0.8
                color: button.buttonColor
            }
        }
    }

    AnimatedImage {
        id: icon

        anchors {
            fill: parent
            margins: 8
        }

        playing: false
        fillMode: Image.PreserveAspectFit
        smooth: true
        rotation: button.portrait ? 0 : 90

        Behavior on rotation {
            RotationAnimation {
                duration: 200
                direction: RotationAnimation.Shortest
            }
        }
    }

    Text {
        id: text

        anchors.centerIn: parent

        font.bold: true
        font.pixelSize: 10
        style: Text.Raised
        styleColor: "black"
        color: "white"
        rotation: button.portrait ? 0 : 90

        Behavior on rotation {
            RotationAnimation {
                duration: 100
                direction: RotationAnimation.Shortest
            }
        }
    }

    opacity: 0.8

    Behavior on scale { PropertyAnimation { duration: 50 } }

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
        onPressed: button.scale = 0.9
        onReleased: button.scale = 1.0
        scale: 1.5
    }
}
