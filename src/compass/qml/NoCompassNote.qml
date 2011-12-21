/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1

BorderDialog {
    id: container

    shown: true
    portrait: ui.portrait

    Text {
        x: 35; y: 42
        color: "#eea604"
        text: "Warning!"
        font.bold: true
        font.pixelSize: container.width * 0.056
    }

    Flickable {
        id: flickable

        anchors {
            fill: parent
            leftMargin: container.border.left
            rightMargin: container.border.right
            topMargin: container.border.top
            bottomMargin: container.border.bottom
        }

        contentWidth: width
        contentHeight: infoText.height
        clip: true

        Text {
            id: infoText

            width: flickable.width
            font.pixelSize: container.width * 0.05
            color: "white"
            text: "<p><b>The application failed to start the compass " +
                  "sensor.</b> This may indicate that your device has not " +
                  "been equipped with the magnetometer hardware sensor " +
                  "required by the compass feature.</p>" +
                  "<p>You can still use the map and location features of " +
                  "the application but the compass will not " +
                  "function properly, i.e. the compass does not give the " +
                  "correct bearing.</p>";

            wrapMode: Text.Wrap
        }
    }

    Rectangle {

        anchors {
            right: parent.right; rightMargin: 18
            bottom: parent.bottom; bottomMargin: 18
        }

        width: Math.min(parent.width, parent.height) * 0.23
        height: Math.max(parent.width, parent.height) * 0.09
        radius: 6
        color: "#434343"

        Behavior on scale {
            PropertyAnimation { duration: 60 }
        }

        Text {
            anchors {
                centerIn: parent
                verticalCenterOffset: -4
            }

            text: "Ok"
            color: "#eea604"
            font.bold: true
            font.pixelSize: parent.height * 0.4
        }

        MouseArea {
            anchors.fill: parent
            onPressed: parent.scale = 0.9
            onReleased: parent.scale = 1.0
            onClicked: container.shown = false
        }
    }
}
