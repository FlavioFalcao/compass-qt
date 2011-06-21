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
    property bool screenSaverInhibited
    property bool feedbackEnabled

    function readSettings() {
        view.model = DB.readSettings()
    }

    function saveRouteCoordinate(time, latitude, longitude, accuracyInMeters) {
        // Commented out for now, when we can draw the route on top of the map
        // this code will be used

        //DB.insertRouteCoordinate(time, latitude, longitude, accuracyInMeters)
    }

    Text {
        x: 35; y: 42
        color: "#eea604"
        text: "Settings"
        font.bold: true
        font.pixelSize: pane.width * 0.056
    }

    ListView {
        id: view

        property real itemHeight: pane.portrait ? view.height / 3
                                                  - view.spacing
                                                : view.height
                                                  - view.spacing
        property real itemWidth: view.width

        anchors {
            fill: parent
            leftMargin: pane.border.left
            rightMargin: pane.border.right
            topMargin: pane.border.top + 2
            bottomMargin: closeRectangle.height +
                          closeRectangle.anchors.bottomMargin + 2
        }

        clip: true
        delegate: delegate
        snapMode: ListView.SnapOneItem
        spacing: 6

        Component {
            id: delegate

            Item {
                width: view.itemWidth - scrollBar.width
                height: view.itemHeight

                Rectangle {
                    anchors {
                        fill: parent
                        margins: border.width
                    }

                    color: "transparent"
                    border.color: "#80EEA604"
                    border.width: 2
                    radius: 4

                    Text {
                        id: nameText

                        anchors {
                            top: parent.top; topMargin: 10
                            left: parent.left; leftMargin: 19
                            right: parent.right; rightMargin: 19
                        }

                        text: name
                        color: "white"
                        font.bold: true
                        font.pixelSize: parent.height * 0.10
                    }

                    BorderImage {
                        id: switchBackground

                        // Binding to models value, do not break this binding
                        property bool enabled: value

                        anchors {
                            top: nameText.bottom; topMargin: 6
                            left: nameText.left
                            right: nameText.right
                            bottom: parent.bottom; bottomMargin: 20
                        }

                        source: "images/switchbackground.sci"

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: parent.width / 5

                            color: "white"
                            text: "On"

                            font.bold: true
                            font.pixelSize: parent.height * 0.25
                        }

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            x: parent.width / 6 * 4

                            color: "white"
                            text: "Off"

                            font.bold: true
                            font.pixelSize: parent.height * 0.25
                        }

                        Rectangle {
                            id: knob

                            // Binding to enabled property which is
                            // binding to models value property
                            x: parent.enabled ? parent.width / 2 + 2 : 2
                            y: 2

                            gradient: Gradient {
                                GradientStop { position: 0.0; color: "#909090" }
                                GradientStop { position: 1.0; color: "#707070" }
                            }

                            width: parent.width / 2 - 4
                            height: parent.height - 4
                            radius: 4
                            color: "#707070"

                            MouseArea {
                                anchors.fill: parent

                                drag.target: parent
                                drag.axis: Drag.XAxis
                                drag.minimumX: 2
                                drag.maximumX: parent.width + 6

                                onClicked: DB.toggleSetting(index)

                                onReleased: {
                                    if (parent.x == 2) {
                                        if(!switchBackground.enabled) {
                                            return
                                        }
                                    }
                                    if (parent.x == (parent.width + 6)) {
                                        if(switchBackground.enabled) {
                                            return
                                        }
                                    }

                                    DB.toggleSetting(index)
                                }
                            }
                        }
                    }
                }
            }
        }

        Rectangle {
            id: scrollBar

            anchors.right: view.right
            y: view.visibleArea.yPosition * view.height
            width: 4; height: view.visibleArea.heightRatio * view.height
            opacity: 0.5
            radius: 2

            color: "#80EEA604"
        }
    }

    Rectangle {
        id: closeRectangle

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
            onClicked: pane.shown = false
        }
    }

    Rectangle {

        anchors {
            left: parent.left; leftMargin: 18
            bottom: parent.bottom; bottomMargin: 18
        }

        width: Math.min(parent.width, parent.height) * 0.3
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

            text: "Defaults"
            color: "#eea604"
            font.bold: true
            font.pixelSize: parent.height * 0.4
        }

        MouseArea {
            anchors.fill: parent
            onPressed: parent.scale = 0.9
            onReleased: parent.scale = 1.0
            onClicked: {
                DB.dropTables()
                view.model = DB.readSettings()
            }
        }
    }
}
