/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

BorderDialog {
    id: container

    Text {
        x: 35; y: 42
        color: "#eea604"
        text: "Compass v1.1"
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
            font.pixelSize: container.width * 0.0389
            color: "white"
            text: "<p>Compass is a Nokia example application that " +
                  "teaches the use of a traditional compass and allows the " +
                  "user to determine the bearing to the desired location " +
                  "using Ovi maps. The main purpose of the example " +
                  "application is to demonstrate the use of the Maps and " +
                  "Navigation API.</p>" +
                  "<p>For more information about the project, see " +
                  "<a href=\"https://projects.developer.nokia.com/compass\">" +
                  "https://projects.developer.nokia.com/compass</a>.</p>" +
                  "<p>The application has two modes: Compass mode and Map " +
                  "mode.</p>" +
                  "<p>In the Map mode you can view the map with your " +
                  "current position retrieved by GPS and indicated with a " +
                  "red circle. The radius of the red circle changes " +
                  "according to the GPS fix accuracy. The more accurate the " +
                  "fix, the smaller the circle; indicating your current " +
                  "location more precisely. The map can be panned by " +
                  "dragging it with a finger. The zoom level can be changed " +
                  "by pinching the map with two fingers. The GPS indicator " +
                  "in the upper left corner will iterate when the phone is " +
                  "trying to retrieve the GPS fix. The indicator is steady " +
                  "when the signal is received from the satellites. Tapping " +
                  "the GPS indicator will pan the map to the current " +
                  "location.</p>" +
                  "<p>To navigate to a certain position in a map:</p>" +
                  "<ul>1. Switch to the Map mode, place the edge of the " +
                  "compass on the map so that it connects the current " +
                  "location with the desired destination, and turn the " +
                  "scale of the compass to the grid north.</ul>" +
                  "<ul>2. Switch back to the Compass mode and turn around " +
                  "with the phone until the compass needle is positioned " +
                  "on top of the outlined orientating arrow. The desired " +
                  "bearing is now in front of you.</ul>" +
                  "<p>The following on / off settings adjust the behavior " +
                  "of the application:</p>" +
                  "Auto north in the map:" +
                  "<ul>Automatically turn the scale of the compass to the " +
                  "grid north when the compass is rotated in the Map " +
                  "mode.</ul>" +
                  "<p>Bearing turnable in the Compass mode:</p>" +
                  "<ul>The turnability of the bearing can be prevented in " +
                  "the Compass mode. By setting the turnability off you can " +
                  "prevent accidential touch events which would affect to " +
                  "the navigation in the field. When turnability is " +
                  "enabled, the compass application can be used with a real " +
                  "paper map.</ul>" +
                  "<p>Prevent screensaver:</p>" +
                  "<ul>Prevents the screensaver from getting activated.</ul>" +
                  "<p>Satellite map:</p>" +
                  "<ul>Toggles between the map and the satellite.</ul>" +
                  "<p>Use sound in calibration:</p>" +
                  "<ul>Defines whether audio feedback is used during the " +
                  "calibration process.</ul><p><br><br></p>"

            wrapMode: Text.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
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

            text: "Close"
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
