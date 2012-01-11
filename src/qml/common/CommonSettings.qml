/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import QtMobility.location 1.2
import CustomElements 1.0

Item {
    id: container

    signal routeCleared();

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
      to the given PannableMap. The Qt implementation calls
      addRoutePointHelper function of the PannableMap.
    */
    function readRoute(map) {
        persistentStorage.loadRoute(map);
    }


    /*!
      Saves route coordinate to the KML. Returns true if the route coordinate
      was the first point of new route, false if the route coordinate was
      added to existing route.
    */
    function saveRouteCoordinate(coordinate, timestamp, accuracyInMeters) {
        var newRoute = false;

        persistentStorage.addRouteCoordinate(
                    coordinate.longitude,
                    coordinate.latitude,
                    coordinate.altitude,
                    privateProperties.storeNextCoordinateAsNewRoute);

        if (privateProperties.storeNextCoordinateAsNewRoute) {
            persistentStorage.createWaypoint("Tracking on",
                                             timestamp,
                                             coordinate.longitude,
                                             coordinate.latitude,
                                             coordinate.altitude);
            privateProperties.storeNextCoordinateAsNewRoute = false;
            privateProperties.lastCoordinateValid = true;
            newRoute = true;
        }

        privateProperties.lastCoordinate = coordinate;
        privateProperties.lastCoordinateTimestamp = timestamp;

        return newRoute;
    }


    /*!
      Sets the tracking on/off. Tracking is defaulty off.
    */
    function setTracking(enabled) {
        privateProperties.storeNextCoordinateAsNewRoute = enabled;
        if (enabled === false) {
            if (privateProperties.lastCoordinateValid == true) {
                persistentStorage.createWaypoint(
                        "Tracking off",
                        privateProperties.lastCoordinateTimestamp,
                        privateProperties.lastCoordinate.longitude,
                        privateProperties.lastCoordinate.latitude,
                        privateProperties.lastCoordinate.altitude);

                privateProperties.lastCoordinateValid = false;
            }
        }

        pane.trackingOn = enabled;
    }


    /*!
      Clears the route(s) stored in persistent storage.
    */
    function clearRoute() {
        persistentStorage.clearRoute();
        container.routeCleared();

        if (container.trackingOn) {
            privateProperties.storeNextCoordinateAsNewRoute = true;
        }
        else {
            privateProperties.storeNextCoordinateAsNewRoute = false;
        }
    }


    /*!
      Sets the screen saver inhibiter on/off, stores the setting to the
      persistent storage.
    */
    function setScreenSaverInhibiter(enabled) {
        container.screenSaverInhibited = enabled;
        persistentStorage.saveSetting(
                    privateProperties.screenSaverInhibitedString,
                    enabled);
    }

    /*!
      Sets the satellite map on/off, stores the setting to the persistent
      storage.
    */
    function setSatelliteMap(enabled) {
        container.satelliteMap = enabled;
        persistentStorage.saveSetting(privateProperties.satelliteMapString,
                                      enabled);
    }

    PersistenStorage {
        id: persistentStorage
    }

    Coordinate {
        id: initialCoordinate
    }

    QtObject {
        id: privateProperties

        // Settings names (keys) used to save/load them to persistent storage.
        property string satelliteMapString: "satelliteMap"
        property string screenSaverInhibitedString: "screenSaverInhibited"
        property string initialLongitudeString: "initialLongitude"
        property string initialLatitudeString: "initialLatitude"

        property bool storeNextCoordinateAsNewRoute: false

        property bool lastCoordinateValid: false
        property variant lastCoordinate
        property variant lastCoordinateTimestamp
    }
}
