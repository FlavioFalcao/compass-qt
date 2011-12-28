/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1

Image {
    id: compass

    signal userRotatedCompass()

    property alias movable: compassMoveArea.enabled
    property alias bearingRotable: bearingMouseArea.enabled
    property alias bearing: scale.rotation
    property alias compassRotable: compassRotateArea.enabled

    property real azimuth: 0

    x: 34
    width: 290; height: 600
    source: "../images/compassplate.png"
    fillMode: Image.PreserveAspectFit
    smooth: true

    MouseArea {
        id: compassRotateArea

        enabled: false

        property real centerx: width / 2
        property real centery: height / 2
        property int previousX: 0
        property int previousY: 0

        anchors.fill: parent

        onPressed: {
            previousX = mouse.x;
            previousY = mouse.y;

            needleBehavior.enabled = false;
        }

        onReleased: {
            needleBehavior.enabled = true;
        }

        onPositionChanged: {
            var ax = mouse.x - centerx;
            var ay = centery - mouse.y;
            var bx = previousX - centerx;
            var by = centery - previousY;

            var angledelta = (Math.atan2(by, bx) - Math.atan2(ay, ax))
                             * 57.2957795;
            if (angledelta > 180) {
                angledelta -= 360;
            }
            else if (angledelta < -180) {
                angledelta += 360;
            }

            compass.rotation = (compass.rotation + angledelta) % 360;
            compass.userRotatedCompass();
        }
    }

    MouseArea {
        id: compassMoveArea

        enabled: false
        anchors {
            fill: parent
            topMargin: compass.height * 0.15
            bottomMargin: compass.height * 0.3
        }

        drag.axis: Drag.XandYAxis
        drag.minimumX: -compass.width * 0.5
        drag.minimumY: -compass.height * 0.3
        drag.maximumX: background.width - compass.width * 0.5
        drag.maximumY: background.height - compass.height * 0.8
        drag.target: parent
    }

    Image {
        id: shadow

        anchors.fill: scale
        source: "../images/scaleshadow.png"
        opacity: 0.8
    }

    Image {
        id: scale

        anchors {
            bottom: parent.bottom; bottomMargin: parent.paintedHeight * 0.145
            horizontalCenter: parent.horizontalCenter
        }

        width: parent.paintedWidth * 0.95
        height: width

        source: "../images/Scale.png"
        smooth: true

        MouseArea {
            id: bearingMouseArea

            property real centerx: width / 2
            property real centery: height / 2
            property int previousX: 0
            property int previousY: 0

            anchors.fill: parent

            onPressed: {
                bearingRotationAnimation.stop();
                previousX = mouse.x
                previousY = mouse.y
            }

            onDoubleClicked: RotationAnimation {
                id: bearingRotationAnimation

                target: scale
                property: "rotation"
                to: -compass.rotation
                duration: 750
                direction: RotationAnimation.Shortest
                easing.type: Easing.InOutCubic
            }

            onPositionChanged: {
                var ax = mouse.x - centerx;
                var ay = centery - mouse.y;
                var bx = previousX - centerx;
                var by = centery - previousY;

                var angledelta = (Math.atan2(by, bx) - Math.atan2(ay, ax))
                                 * 57.2957795;
                if (angledelta > 180) {
                    angledelta -= 360;
                }
                else if (angledelta < -180) {
                    angledelta += 360;
                }

                scale.rotation = (scale.rotation + angledelta) % 360;
            }
        }
    }

    Image {
        id: needle

        anchors.centerIn: scale
        height: scale.paintedHeight * 0.56
        width: height * 0.1214

        source: "../images/compassneedle.png"
        smooth: true

        rotation: -azimuth - compass.rotation
        Behavior on rotation {
            id: needleBehavior

            RotationAnimation {
                duration: 100
                direction: RotationAnimation.Shortest
            }
        }
    }
}
