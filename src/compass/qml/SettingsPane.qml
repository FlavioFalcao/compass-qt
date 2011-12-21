/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import CustomElements 1.0


Item {
    id: pane

    signal clearRoute();

    property bool satelliteMap
    property bool screenSaverInhibited
    property bool trackingOn: false

    /*!
      Read settings from DB.
    */
    function readSettings() {
        satelliteMap = persistentStorage.loadSetting(
                    persistentStorage.satelliteMap, false);

        screenSaverInhibited = persistentStorage.loadSetting(
                    persistentStorage.screenSaverInhibited, false);
    }


    /*
      Reads the stored route from the DB and places it
      to the given MapPolyLine element.
    */
    function readRoute(route) {
        persistentStorage.loadRoute(route);
    }


    /*!
      Saves route coordinate to the DB.
    */
    function saveRouteCoordinate(time, coordinate, accuracyInMeters) {
        persistentStorage.addRouteCoordinate(coordinate.longitude,
                                             coordinate.latitude,
                                             coordinate.altitude);
    }

    onOpacityChanged: {
        // Work-around for
        // https://bugreports.qt.nokia.com/browse/QTCOMPONENTS-1178
        if (opacity == 1.0) {
            // Setting is now visible, update all button rows
            if (satelliteMap) {
                mapTypeButtonRow.checkedButton = mapTypeSatelliteMapDay;
            }
            else {
                mapTypeButtonRow.checkedButton = mapTypeStreetMap;
            }

            if (screenSaverInhibited) {
                screenTimeoutButtonRow.checkedButton = screenTimeoutOn;
            }
            else {
                screenTimeoutButtonRow.checkedButton = screenTimeoutOff;
            }

            // The tracking is always defaultly off
            if (pane.trackingOn) {
                trackingButtonRow.checkedButton = trackingOn;
            }
            else {
                trackingButtonRow.checkedButton = trackingOff;
            }
        }
    }

    PersistenStorage {
        id: persistentStorage

        property string satelliteMap: "satelliteMap"
        property string screenSaverInhibited: "screenSaverInhibited"
    }

    Item {
        id: screenLockSetting

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.horizontalCenter; rightMargin: 4
        }

        height: 80

        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: "black"
        }

        Text {
            id: screenTimeoutText

            x: 3; y: 3
            font.pointSize: 5
            color: "white"
            text: "Screen/keylock timeout";
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: screenTimeoutButtonRow

            anchors {
                top: screenTimeoutText.bottom; topMargin: 3
                horizontalCenter: parent.horizontalCenter
            }

            exclusive: true

            Button {
                id: screenTimeoutOn

                checkable: true
                text: "On"
                onClicked: {
                    pane.screenSaverInhibited = true;
                    persistentStorage.saveSetting(
                                persistentStorage.screenSaverInhibited,
                                true);
                }
            }

            Button {
                id: screenTimeoutOff

                checkable: true
                text: "Off"
                onClicked: {
                    pane.screenSaverInhibited = false;
                    persistentStorage.saveSetting(
                                persistentStorage.screenSaverInhibited,
                                false);
                }
            }
        }
    }

    Item {
        id: mapStyleSetting

        anchors {
            bottom: parent.bottom
            left: parent.horizontalCenter; leftMargin: 4
            right: parent.right
        }

        height: 80

        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: "black"
        }

        Text {
            id: mapStyleText

            x: 3; y: 3
            font.pointSize: 5
            color: "white"
            text: "Map style"
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: mapTypeButtonRow

            anchors {
                top: mapStyleText.bottom; topMargin: 3
                horizontalCenter: parent.horizontalCenter
            }

            exclusive: true

            Button {
                id: mapTypeStreetMap

                checkable: true
                text: "Street"
                onClicked: {
                    pane.satelliteMap = false;
                    persistentStorage.saveSetting(
                                persistentStorage.satelliteMap,
                                false);
                }
            }

            Button {
                id: mapTypeSatelliteMapDay

                checkable: true
                text: "Sat"
                onClicked: {
                    pane.satelliteMap = true;
                    persistentStorage.saveSetting(
                                persistentStorage.satelliteMap,
                                true);
                }
            }
        }
    }

    Item {
        id: trackingSetting

        anchors {
            left: parent.left
            right: parent.right
            bottom: screenLockSetting.top; bottomMargin: 10
        }

        height: 80

        Rectangle {
            anchors.fill: parent
            opacity: 0.5
            color: "black"
        }

        Item {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.horizontalCenter; rightMargin: 4
            }

            Text {
                id: trackingText

                x: 3; y: 3
                font.pointSize: 5
                color: "white"
                text: "Tracking"
                style: Text.Raised
                styleColor: "gray"
            }

            ButtonRow {
                id: trackingButtonRow

                anchors {
                    top: trackingText.bottom; topMargin: 3
                    horizontalCenter: parent.horizontalCenter
                }

                checkedButton: trackingOff

                Button {
                    id: trackingOn

                    text: "On"
                    onClicked: {
                        pane.trackingOn = true;
                        //persistentStorage.createWaypoint();
                    }
                }

                Button {
                    id: trackingOff

                    text: "Off"
                    onClicked: pane.trackingOn = false;
                }
            }
        }

        Item {
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.horizontalCenter; leftMargin: 4
                right: parent.right
            }

            Button {
                anchors.centerIn: parent

                text: "Clear"
                onClicked: {
                    persistentStorage.clearRoute();
                    pane.clearRoute();
                }
            }
        }
    }
}
