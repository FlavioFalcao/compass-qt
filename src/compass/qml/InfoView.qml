/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0

Item {
    id: container

    property bool shown: false
    property bool portrait

    width: 500; height: 300

    BorderImage {
        id: background

        anchors.centerIn: parent
        width: container.portrait ? container.width : container.height
        height: container.portrait ? container.height : container.width

        rotation: container.portrait ? 0 : 90
        opacity: container.shown ? 1.0 : 0.0

        Behavior on width { PropertyAnimation { duration: 100 } }
        Behavior on height { PropertyAnimation { duration: 100 } }

        Behavior on rotation {
            RotationAnimation {
                direction: RotationAnimation.Shortest
                duration: 100
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on opacity { PropertyAnimation { duration: 250 } }

        source: "images/infoback.png"

        border.top: 90
        border.bottom: 70
        border.left: 35
        border.right: 100

        Text {
            x: 35; y: 45
            color: "#eea604"
            text: "Compass application v0.1.0"
            font.bold: true
            font.pixelSize: 20
        }

        Flickable {
            id: flickable

            anchors {
                fill: parent
                leftMargin: background.border.left
                rightMargin: 30
                topMargin: background.border.top
                bottomMargin: background.border.bottom
            }

            contentWidth: width
            contentHeight: infoText.height
            clip: true

            Text {
                id: infoText

                width: flickable.width
                color: "white"
                text: "Compass is an application that teaches the use of " +
                      "traditional compass and allows the user to have a " +
                      "bearing to the desired place using the Ovi maps.\n" +
                      "The application consists two modes: Track mode and " +
                      "Map mode.\n" +
                      "In the Map mode you are able to view the map  with " +
                      "your current position retrieved by GPS and shown " +
                      "with a red circle. The radius of the red circle will " +
                      "change according to the GPS fix accuracy. The more " +
                      "accurate fix the more smaller circle is shown giving " +
                      "you more precise location of you current whereabout. " +
                      "The map can be panned by dragging the map with a " +
                      "finger. The zoom level can be changed by pinching the " +
                      "map with two fingers.\n" +
                      "To navigate to some position in a map do the " +
                      "following, first switch to the Map mode, place the " +
                      "edge of the compass on the map so that it connects " +
                      "the current location with the desired destination " +
                      "and turn the scale of the compass to the map north. " +
                      "Now, enter to the Track mode and turn with the phone " +
                      "as long as the compass needle is positioned on top of " +
                      "the outlined orientating arrow. The desired bearing " +
                      "is now at your front."

                wrapMode: Text.WordWrap
            }
        }

        Item {

            anchors {
                right: parent.right; rightMargin: 27
                bottom: parent.bottom; bottomMargin: 27
            }

            width: 70; height: 40

            Text {
                anchors.centerIn: parent
                text: "Close"
                color: "#eea604"
                font.bold: true
                font.pixelSize: 15
            }

            MouseArea {
                anchors.fill: parent
                onClicked: container.shown = false
            }
        }
    }
}
