/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1


Page {
    id: container

    property string version: "1.3"

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                container.pageStack.pop();
                container.pageStack.currentPage.showToolBar();
            }
        }
    }

    Component.onCompleted: {
        // Extra step is required to set the custom toolbar
        window.myTools = tools;
    }

    Flickable {
        id: flickable

        anchors {
            fill: parent
            margins: 8
        }

        contentWidth: width
        contentHeight: infoText.height
        clip: true

        Text {
            id: infoText

            width: flickable.width
            font.pixelSize: container.width * 0.0389
            color: "white"
            text: "<h2>Compass v" + container.version + "</h2>" +
                  "<p>Compass is a Nokia example application that " +
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
                  "<p>Screen/keyloack timeout:</p>" +
                  "<ul>Prevents the screensaver from getting activated.</ul>" +
                  "<p>Map style:</p>" +
                  "<ul>Toggles between the map and the satellite.</ul>" +
                  "<p><br><br></p>"

            wrapMode: Text.Wrap
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }

    ScrollDecorator {
        flickableItem: flickable
    }
}
