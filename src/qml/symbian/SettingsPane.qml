/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import QtMobility.location 1.2
import com.nokia.symbian 1.1
import CustomElements 1.0


Item {
    id: pane

    signal clearRoute();

    property bool satelliteMap
    property bool screenSaverInhibited
    property bool trackingOn: false

    /*!
      Read settings from persistent storage. Returns the initial coordinate,
      the coordinate where the application were used last time.
    */
    function readSettings() {
        satelliteMap = persistentStorage.loadSetting(
                    privateProperties.satelliteMapString, false);

        screenSaverInhibited = persistentStorage.loadSetting(
                    privateProperties.screenSaverInhibitedString, false);

        initialCoordinate.longitude = persistentStorage.loadSetting(
                    privateProperties.initialLongitudeString, 25.7573175);

        initialCoordinate.latitude = persistentStorage.loadSetting(
                    privateProperties.initialLatitudeString, 62.2410021);

        return initialCoordinate;
    }


    /*!
      Saves the initial coordinate to persistent storage. Initial coordinate
      is used when the application is opened next time, to open the map
      where it was last time.
    */
    function saveInitialCoordinate(coordinate) {
        persistentStorage.saveSetting(
                    privateProperties.initialLongitudeString,
                    coordinate.longitude);
        persistentStorage.saveSetting(
                    privateProperties.initialLatitudeString,
                    coordinate.latitude);
    }


    /*!
      Reads the stored route from KML file and places it
      to the given MapPolyLine element.
    */
    function readRoute(route) {
        persistentStorage.loadRoute(route);
    }


    /*!
      Saves route coordinate to the KML.
    */
    function saveRouteCoordinate(coordinate, timestamp, accuracyInMeters) {
        persistentStorage.addRouteCoordinate(coordinate.longitude,
                                             coordinate.latitude,
                                             coordinate.altitude);

        if (privateProperties.saveNextCoordinateAsWaypoint == true) {
            persistentStorage.createWaypoint(privateProperties.nextWaypointName,
                                             timestamp,
                                             coordinate.longitude,
                                             coordinate.latitude,
                                             coordinate.altitude);
            privateProperties.saveNextCoordinateAsWaypoint = false;
            privateProperties.lastCoordinateValid = true;
        }

        privateProperties.lastCoordinate = coordinate;
        privateProperties.lastCoordinateTimestamp = timestamp;
    }

    onOpacityChanged: {
        // Work-around for
        // https://bugreports.qt.nokia.com/browse/QTCOMPONENTS-1178
        if (opacity == 1.0) {
            // SettingsPane is now visible, update all button rows
            if (satelliteMap) {
                mapTypeButtonRow.checkedButton = mapTypeSatelliteMapDay;
            }
            else {
                mapTypeButtonRow.checkedButton = mapTypeStreetMap;
            }

            if (pane.screenSaverInhibited) {
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

    Coordinate {
        id: initialCoordinate
    }

    QtObject {
        id: privateProperties

        property string satelliteMapString: "satelliteMap"
        property string screenSaverInhibitedString: "screenSaverInhibited"
        property string initialLongitudeString: "initialLongitude"
        property string initialLatitudeString: "initialLatitude"

        property bool saveNextCoordinateAsWaypoint: false
        property string nextWaypointName

        property bool lastCoordinateValid: false
        property variant lastCoordinate
        property variant lastCoordinateTimestamp
    }

    PersistenStorage {
        id: persistentStorage
    }

    Image {
        id: screenLockSetting

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.horizontalCenter; rightMargin: 4
        }

        height: 80
        source: "../images/symbian_toolbar.png"

        Text {
            id: screenTimeoutText

            x: 5; y: 5
            font.pointSize: 5
            color: "white"
            text: "Screen timeout";
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: screenTimeoutButtonRow

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.right; rightMargin: 12
            }

            exclusive: true

            Button {
                id: screenTimeoutOn

                checkable: true
                text: "On"
                onClicked: {
                    pane.screenSaverInhibited = true;
                    persistentStorage.saveSetting(
                                privateProperties.screenSaverInhibitedString,
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
                                privateProperties.screenSaverInhibitedString,
                                false);
                }
            }
        }
    }

    Image {
        id: mapStyleSetting

        anchors {
            bottom: parent.bottom
            left: parent.horizontalCenter; leftMargin: 4
            right: parent.right
        }

        height: 80
        source: "../images/symbian_toolbar.png"

        Text {
            id: mapStyleText

            x: 5; y: 5
            font.pointSize: 5
            color: "white"
            text: "Map style"
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: mapTypeButtonRow

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.right; rightMargin: 12
            }

            exclusive: true

            Button {
                id: mapTypeStreetMap

                checkable: true
                text: "Street"
                onClicked: {
                    pane.satelliteMap = false;
                    persistentStorage.saveSetting(
                                privateProperties.satelliteMapString,
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
                                privateProperties.satelliteMapString,
                                true);
                }
            }
        }
    }

    Image {
        id: trackingSetting

        anchors {
            left: parent.left
            right: parent.right
            bottom: screenLockSetting.top; bottomMargin: 10
        }

        height: 80
        source: "../images/symbian_toolbar.png"

        Text {
            id: trackingText

            x: 5; y: 5
            font.pointSize: 5
            color: "white"
            text: "Tracking"
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: trackingButtonRow

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.horizontalCenter; rightMargin: 12 + 4
            }

            checkedButton: trackingOff

            Button {
                id: trackingOn

                text: "On"
                onClicked: {
                    // Enable the tracking, when the first coordinate is
                    // retrieved from the position source a waypoint will
                    // also be stored to KML.
                    privateProperties.saveNextCoordinateAsWaypoint = true;
                    privateProperties.nextWaypointName = "Tracking on";
                    pane.trackingOn = true;
                }
            }

            Button {
                id: trackingOff

                text: "Off"
                onClicked: {
                    if (privateProperties.lastCoordinateValid == true) {
                        persistentStorage.createWaypoint(
                                "Tracking off",
                                privateProperties.lastCoordinateTimestamp,
                                privateProperties.lastCoordinate.longitude,
                                privateProperties.lastCoordinate.latitude,
                                privateProperties.lastCoordinate.altitude);

                        privateProperties.lastCoordinateValid = false;
                    }

                    pane.trackingOn = false;
                }
            }
        }

        Button {
            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.right; rightMargin: 44
            }

            text: "Clear"
            onClicked: {
                persistentStorage.clearRoute();
                pane.clearRoute();
            }
        }
    }
}
