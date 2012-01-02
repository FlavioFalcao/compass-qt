/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "../common"


Page {
    id: container

    property string version: "1.3"

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                container.pageStack.pop();

                // This is required to show our custom toolbar
                container.pageStack.currentPage.showToolBar();
            }
        }
    }

    Component.onCompleted: {
        // Extra step is required to set the custom toolbar
        window.myTools = tools;
    }

    BorderDialog {
        id: dialog

        anchors {
            fill: parent
            bottomMargin: container.tools.height
        }

        heading: Text {
            anchors.verticalCenter: parent.verticalCenter

            color: "#eea604"
            text: "<h2>Compass v" + container.version + "</h2>"
            font.bold: true
            font.pixelSize: platformStyle.fontSizeLarge
        }

        Flickable {
            id: flickable

            anchors.fill: parent

            contentWidth: width
            contentHeight: infoText.height
            clip: true

            Text {
                id: infoText

                width: flickable.width - 10
                font.pixelSize: platformStyle.fontSizeMedium
                color: "white"
                horizontalAlignment: Text.AlignJustify
                text: "<p>Compass is a Nokia example application that " +
                      "teaches the use of a traditional compass and allows the " +
                      "user to determine the bearing to the desired location " +
                      "using Nokia maps. The main purpose of the example " +
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
                      "by pinching the map with two fingers.</p>" +
                      "<p>To navigate to a certain position in a map:</p>" +
                      "<ul>1. Switch to the Map mode, place the edge of the " +
                      "compass on the map so that it connects the current " +
                      "location with the desired destination, and turn the " +
                      "scale of the compass to the grid north.</ul>" +
                      "<ul>2. Switch back to the Compass mode and turn around " +
                      "with the phone until the compass needle is positioned " +
                      "on top of the outlined orientating arrow. The desired " +
                      "bearing is now in front of you.</ul>" +
                      "<p>The following settings adjust the behavior of the " +
                      "application:</p>" +
                      "<p>Tracking</p>" +
                      "<ul>Gathers walked route points. The Clear button clears " +
                      "the route.</ul>" +
                      "<p>Screen timeout:</p>" +
                      "<ul>Prevents the screensaver from getting activated.</ul>" +
                      "<p>Satellitem map:</p>" +
                      "<ul>Toggles between satellite and streep map.</ul>" +
                      "<p>Note. The gathered route is stored in " +
                      "<i>E:\\Compass.kml</i> file and it can be opened in " +
                      "external map application.</p>"

                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        ScrollDecorator {
            flickableItem: flickable
        }
    }
}
