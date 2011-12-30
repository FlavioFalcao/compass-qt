/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import QtMobility.location 1.2
import com.nokia.meego 1.0
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


        screenTimeoutSwitch.checked = screenSaverInhibited;
        satelliteMapSwitch.checked = satelliteMap;
        trackingSwitch.checked = trackingOn;

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

    Rectangle {
        id: screenLockSetting

        color: "#CC000000"
        height: 70

        anchors {
            bottom: parent.bottom; bottomMargin: 6
            left: parent.left
            right: parent.horizontalCenter; rightMargin: 2
        }

        Text {
            id: screenTimeoutText

            anchors {
                left: parent.left; leftMargin: 6
                top: parent.top; topMargin: 6
            }

            font.pointSize: 14
            color: "white"
            text: "Screen timeout";
            style: Text.Raised
            styleColor: "gray"
        }

        Switch {
            id: screenTimeoutSwitch

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right; rightMargin: 12
            }

            onCheckedChanged: {
                if (checked) {
                    pane.screenSaverInhibited = true;
                    persistentStorage.saveSetting(
                                privateProperties.screenSaverInhibitedString,
                                true);
                }
                else {
                    pane.screenSaverInhibited = false;
                    persistentStorage.saveSetting(
                                privateProperties.screenSaverInhibitedString,
                                false);
                }
            }
        }
    }

    Rectangle {
        id: mapStyleSetting

        color: "#CC000000"
        height: 70

        anchors {
            bottom: parent.bottom; bottomMargin: 6
            left: parent.horizontalCenter; leftMargin: 2
            right: parent.right
        }

        Text {
            id: mapStyleText

            anchors {
                left: parent.left; leftMargin: 6
                top: parent.top; topMargin: 6
            }

            font.pointSize: 14
            color: "white"
            text: "Satellite map"
            style: Text.Raised
            styleColor: "gray"
        }

        Switch {
            id: satelliteMapSwitch

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.right; rightMargin: 12
            }

            onCheckedChanged: {
                if (checked) {
                    pane.satelliteMap = true;
                    persistentStorage.saveSetting(
                                privateProperties.satelliteMapString,
                                true);
                }
                else {
                    pane.satelliteMap = false;
                    persistentStorage.saveSetting(
                                privateProperties.satelliteMapString,
                                false);
                }
            }
        }
    }

    Rectangle {
        id: trackingSetting

        anchors {
            left: parent.left
            right: parent.right
            bottom: screenLockSetting.top; bottomMargin: 6
        }

        color: "#CC000000"
        height: 70

        Text {
            id: trackingText

            anchors {
                left: parent.left; leftMargin: 6
                top: parent.top; topMargin: 6
            }

            font.pointSize: 14
            color: "white"
            text: "Tracking"
            style: Text.Raised
            styleColor: "gray"
        }

        Switch {
            id: trackingSwitch

            anchors {
                verticalCenter: parent.verticalCenter
                right: parent.horizontalCenter; rightMargin: 14
            }

            onCheckedChanged: {
                if (checked) {
                    // Enable the tracking, when the first coordinate is
                    // retrieved from the position source a waypoint will
                    // also be stored to KML.
                    privateProperties.saveNextCoordinateAsWaypoint = true;
                    privateProperties.nextWaypointName = "Tracking on";
                    pane.trackingOn = true;
                }
                else {
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

        ToolIcon {
            anchors {
                verticalCenter:  parent.verticalCenter
                right: parent.right; rightMargin: 6
            }
            platformIconId: "toolbar-delete"
            onClicked: {
                persistentStorage.clearRoute();
                pane.clearRoute();
            }
        }
    }
}
