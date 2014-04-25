/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1

Image {
    id: container

    signal hidden();

    function startHideAnimation() {
        hideAnimation.start();
    }

    anchors.fill: parent
    width: 360; height: 640
    z: 10
    source: "../images/compass_back.png"
    fillMode: Image.Tile

    Text {
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: shadow.top; bottomMargin: 0.05 * parent.height
        }
        text: "Loading..."
        color: "black"
        font.pixelSize: 40
    }

    Image {
        id: shadow

        anchors.fill: scale
        source: "../images/scaleshadow.png"
        smooth: true
        opacity: 0.8
    }

    Image {
        id: scale

        anchors {
            bottom: parent.bottom; bottomMargin: 25
            left: parent.left; leftMargin: 5
            right: parent.right; rightMargin: 5
        }

        height: width
        source: "../images/Scale.png"
        smooth: true
    }

    Image {
        id: needle

        anchors.centerIn: scale
        width: height * 0.1214; height: scale.paintedHeight * 0.56
        source: "../images/compassneedle.png"
        smooth: true
    }


    PropertyAnimation {
        running: true
        loops: Animation.Infinite

        target: needle
        property: "rotation"
        duration: 3000
        from: 0
        to: 359
    }


    SequentialAnimation {
        id: hideAnimation

        PropertyAnimation {
            target: container
            property: "opacity"
            to: 0.0
            duration: 500
        }
        ScriptAction {
            script: container.hidden();
        }
    }
}
