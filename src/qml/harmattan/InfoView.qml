/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import "../common"


Page {
    id: container

    property string version: "2.0"

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolIcon {
            platformIconId: "toolbar-back"
            onClicked: {
                container.pageStack.pop();
            }
        }
    }

    BorderDialog {
        id: dialog

        anchors {
            fill: parent
            bottomMargin: container.tools.height
        }

        source: "../images/infoback_harmattan.png"
        heading: Text {
            anchors.verticalCenter: parent.verticalCenter

            color: "#555555"
            text: "<h2>Compass v" + container.version + "</h2>"
            font.pixelSize: 26
            styleColor: "white"
            style: Text.Raised
        }

        Flickable {
            id: flickable

            anchors.fill: parent

            contentWidth: width
            contentHeight: infoText.height + 20

            Text {
                id: infoText

                y: 10
                width: flickable.width - 20
                font.pixelSize: 20
                color: "#202020"
                text: "<p>Compass is a Nokia Developer example application " +
                      "that teaches the use of a traditional compass and " +
                      "allows the user to determine the bearing to the " +
                      "desired location using Nokia maps. The main purpose " +
                      "of the example application is to demonstrate the use " +
                      "of the Maps and Navigation API.</p>" +
                      "<p>For more information about the project, please see " +
                      "<a href=\"https://projects.developer.nokia.com/compass\">" +
                      "https://projects.developer.nokia.com/compass</a>.</p>" +
                      "<p>The application has two modes: Compass mode and Map " +
                      "mode.</p>" +
                      "<p>In the Map mode you can view the map with your " +
                      "current position retrieved by GPS and indicated with a " +
                      "red circle. The radius of the red circle changes " +
                      "according to the GPS fix accuracy. The more accurate the " +
                      "fix, the smaller the circle, indicating your current " +
                      "location is presented more precisely. The map can be " +
                      "panned by dragging it with a finger. The zoom level can " +
                      "be changed by pinching the map with two fingers.</p>" +
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
                      "<ul>Gathers walked route points. The recycle bin icon " +
                      "clears the route.</ul>" +
                      "<p>Satellite map:</p>" +
                      "<ul>Toggles between satellite and street map.</ul>" +
                      "<p>Note. The gathered route is stored in " +
                      "<i>/home/user/Compass.kml</i> file and it can be opened "+
                      "in external map application.</p>"

                wrapMode: Text.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }

        ScrollDecorator {
            flickableItem: flickable
        }
    }
}
