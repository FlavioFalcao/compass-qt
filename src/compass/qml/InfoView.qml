/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

BorderDialog {
    id: container

    Text {
        x: 35; y: 45
        color: "#eea604"
        text: "Compass v1.0"
        font.bold: true
        font.pixelSize: 20
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
            font.pixelSize: 14
            color: "white"
            text: "<p>Compass is a Forum Nokia example that teaches the use " +
                  "of traditional compass and allows the user to have a " +
                  "bearing to the desired place using the Ovi maps. The " +
                  "main purpose of the example is to demonstrate use of " +
                  "Maps and navigation API. See more information about the " +
                  "project at " +
                  "<a href=\"https://projects.forum.nokia.com/compass\">" +
                  "https://projects.forum.nokia.com/compass</a>.</p>" +
                  "<p>The application consists two modes: Compass mode and " +
                  "Map mode.</p>" +
                  "<p>In the Map mode you are able to view the map  with " +
                  "your current position retrieved by GPS and shown " +
                  "with a red circle. The radius of the red circle will " +
                  "change according to the GPS fix accuracy. The more " +
                  "accurate fix the more smaller circle is shown giving " +
                  "you more precise location of you current whereabout. " +
                  "The map can be panned by dragging the map with a " +
                  "finger. The zoom level can be changed by pinching the " +
                  "map with two fingers.The GPS indicator on the upper left " +
                  "corner will iterate when the phone is trying to retrieve " +
                  "the GPS fix. The indicator is steady when the signal is " +
                  "received from the satellites. Tapping the GPS indicator " +
                  "will pan the map to the current location.</p>" +
                  "<p>To navigate to some position in a map do the " +
                  "following: First switch to the Map mode, place the " +
                  "edge of the compass on the map so that it connects " +
                  "the current location with the desired destination " +
                  "and turn the scale of the compass to the map north. " +
                  "Now, enter to the Compass mode and turn with the phone " +
                  "as long as the compass needle is positioned on top of " +
                  "the outlined orientating arrow. The desired bearing " +
                  "is now at your front.</p><p>\n</p>"

            wrapMode: Text.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }

    Rectangle {

        anchors {
            right: parent.right; rightMargin: 18
            bottom: parent.bottom; bottomMargin: 18
        }

        width: 79; height: 49
        radius: 10
        color: "#434343"

        Behavior on scale {
            PropertyAnimation { duration: 60 }
        }

        Text {
            anchors.centerIn: parent
            text: "Close"
            color: "#eea604"
            font.bold: true
            font.pixelSize: 15
        }

        MouseArea {
            anchors.fill: parent
            onPressed: parent.scale = 0.9
            onReleased: parent.scale = 1.0
            onClicked: container.shown = false
        }
    }
}
