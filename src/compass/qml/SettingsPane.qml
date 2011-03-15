/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import "settings.js" as DB

BorderDialog {
    id: pane

    property bool autoNorthInMap
    property bool bearingTurnInTrackMode
    property bool satelliteMap
    property bool screenSaverInhibited: false

    function saveRouteCoordinate(time, latitude, longitude, accuracyInMeters) {
        // Commented out for now, when we can draw the route on top of the map
        // this code will be used
        //DB.insertRouteCoordinate(time, latitude, longitude, accuracyInMeters)
    }

    onAutoNorthInMapChanged: console.log("autoNorhInMap: " + autoNorthInMap)
    onBearingTurnInTrackModeChanged: console.log("bearingTurnInTrackMode: " + bearingTurnInTrackMode)
    onSatelliteMapChanged: console.log("satelliteMap: " + satelliteMap)
    onScreenSaverInhibitedChanged: console.log("screenSaverInhibited: " + screenSaverInhibited)

    Component.onCompleted: {
        // Uncomment to drop and recreate tables
        //DB.resetDB()
        view.model = DB.readSettings()
    }

    Text {
        x: 35; y: 45
        color: "#eea604"
        text: "Settings"
        font.bold: true
        font.pixelSize: 20
    }


    PathView {
        id: view

        anchors {
            fill: parent
            leftMargin: pane.border.left
            rightMargin: pane.border.right
            topMargin: pane.border.top
            bottomMargin: pane.border.bottom
        }

        clip: true
        offset: 20
        delegate: delegate
        path: Path {
            startX: view.width / 2; startY:  -50
            PathLine { x: view.width / 2; y: view.height + 50}
        }

        Component {
            id: delegate

            Item {
                width: view.width; height: view.height / 6

                Text {
                    id: nameText

                    x: 20
                    width: parent.width - x - 10
                    text: name
                    color: "white"
                    wrapMode: Text.WordWrap
                    font.bold: true
                    font.pixelSize: 14
                }

                Rectangle {
                    id: valueText

                    property bool enabled: value

                    anchors {
                        top: nameText.bottom; topMargin: 2
                        left: nameText.left; leftMargin: 0
                        right: parent.right; rightMargin: 20
                        bottom: parent.bottom; bottomMargin: 25
                    }

                    radius: 4
                    color: "#999999"

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: parent.width / 5

                        color: "white"
                        text: "On"

                        font.bold: true
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        x: parent.width / 5 * 3

                        color: "white"
                        text: "Off"

                        font.bold: true
                    }

                    Rectangle {
                        x: valueText.enabled ? parent.width / 2 : 2
                        y: 2

                        Behavior on x { PropertyAnimation { duration: 100 } }

                        width: parent.width / 2 - 4; height: parent.height - 4
                        radius: 4
                        color: "#707070"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        var item = view.model.get(index)

                        if(item.value == 0) {
                            item.value = 1
                        }
                        else {
                            item.value = 0
                        }

                        DB.saveSetting(item.name, item.value)
                        DB.updateProperties(item)
                    }
                }
            }
        }
    }
}
