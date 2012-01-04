/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import QtMobility.location 1.2

Item {
    id: pannableMap

    property alias zoomLevel: map.zoomLevel
    property alias mapCenter: map.center
    property alias route: route
    property bool satelliteMap: false
    property alias hereCenter: mapCircle.center
    property alias hereAccuracy: mapCircle.radius
    property alias mapElement: map

    /*
      Adds a coordinate to the walked route.
    */
    function addRoute(coordinate) {
        route.addCoordinate(coordinate);

        if (route.path.length > 1) {
            route.visible = true;
        }
    }

    /*
      Clears the walked route.
    */
    function clearRoute() {
        while (route.path.length > 0) {
            var coordinate = route.path[route.path.length-1];
            route.removeCoordinate(coordinate);
        }

        // Work around fix
        route.visible = false;
    }

    /*
      Returns the distance of the given coordinate and the last coordinate on
      walked route. If walked route does not exist, returns -1.
    */
    function distanceToLastRouteCoordinate(coordinate) {
        var length = route.path.length;

        if (length === 0) {
            return -1;
        }

        return route.path[length-1].distanceTo(coordinate);
    }

    function moveHereToCoordinate(coordinate, accuracyInMeters) {
        hereCenterAnimation.latitude = coordinate.latitude;
        hereCenterAnimation.longitude = coordinate.longitude;
        hereCenterAnimation.accuracyInMeters = accuracyInMeters;
        hereCenterAnimation.restart();
    }

    function panToCoordinate(coordinate) {
        panAnimation.latitude = coordinate.latitude;
        panAnimation.longitude = coordinate.longitude;
        panAnimation.restart();
    }

    Map {
        id: map

        anchors {
            fill: parent
        }

        plugin : Plugin { name : "nokia" }
        zoomLevel: 14
        connectivityMode: Map.OnlineMode
        mapType: pannableMap.satelliteMap ? Map.SatelliteMapDay
                                          : Map.StreetMap

        // The initial coordinate where map opens.
        center: Coordinate {
            longitude: 25.7573175
            latitude: 62.2410021
        }

        Coordinate {
            id: coordinateTemplate

            longitude: 25.7573175
            latitude: 62.2410021
        }

        MapPolyline {
            id: route

            /*!
              Used to add route points when loading the existing route from
              KML file by PersistentStorage object.
            */
            function addRoutePoint(longitude, latitude) {
                coordinateTemplate.latitude = latitude;
                coordinateTemplate.longitude = longitude;

                // coordinateTemplate is used to construct Coordinate element.
                route.addCoordinate(coordinateTemplate);
            }

            border.color: "red"
            border.width: 2
        }

        MapCircle {
            id: mapCircle

            center: Coordinate {
                longitude: 25.7573175
                latitude: 62.2410021
            }

            color: "#40FF0000"
            border.color: Qt.darker(color)
            border.width: 3
        }
    }

    PinchArea {
        id: pincharea

        property double oldZoomLevel

        function calcZoomDelta(zoom, percent) {
            var zoomLevel = zoom + Math.log(percent) / Math.log(2);
            zoomLevel = Math.round(zoomLevel);
            if (zoomLevel > map.maximumZoomLevel) {
                zoomLevel = map.maximumZoomLevel;
            }
            else if (zoomLevel < map.minimumZoomLevel) {
                zoomLevel = map.minimumZoomLevel;
            }

            return zoomLevel;
        }

        anchors.fill: parent
        onPinchStarted: {
            oldZoomLevel = map.zoomLevel;
        }

        onPinchUpdated: {
            if (oldZoomLevel >= map.maximumZoomLevel &&
                    pinch.scale > 1.0) {
                // Don't allow the user to zoom more than the map supports
                return;
            }
            else if (oldZoomLevel <= map.minimumZoomLevel &&
                     pinch.scale < 1.0) {
                // Don't allow the user to zoom less than the map supports
                return;
            }

            map.scale = pinch.scale;
        }

        onPinchFinished: {
            map.zoomLevel = calcZoomDelta(oldZoomLevel, pinch.scale);
            map.scale = 1;
        }
    }

    MouseArea {
        id: panMouseArea

        property bool mouseDown: false
        property int lastX: -1
        property int lastY: -1

        anchors.fill: parent

        onPressed: {
            panAnimation.stop();
            mouseDown = true;
            lastX = mouse.x;
            lastY = mouse.y;
        }

        onReleased: {
            mouseDown = false;
            lastX = -1;
            lastY = -1;
        }

        onPositionChanged: {
            if (mouseDown) {
                var dx = mouse.x - lastX;
                var dy = mouse.y - lastY;
                map.pan(-dx, -dy);
                lastX = mouse.x;
                lastY = mouse.y;
            }
        }

        onCanceled: {
            mouseDown = false;
        }
    }

    ParallelAnimation {
        id: hereCenterAnimation

        property real latitude
        property real longitude
        property real accuracyInMeters

        PropertyAnimation {
            target: mapCircle
            property: "center.latitude"
            to: hereCenterAnimation.latitude
            easing.type: Easing.InOutCubic
            duration: 1000
        }

        PropertyAnimation {
            target: mapCircle
            property: "center.longitude"
            to: hereCenterAnimation.longitude
            easing.type: Easing.InOutCubic
            duration: 1000
        }

        PropertyAnimation {
            target: mapCircle
            property: "radius"
            to: hereCenterAnimation.accuracyInMeters
            easing.type: Easing.InOutCubic
            duration: 1000
        }
    }

    ParallelAnimation {
        id: panAnimation

        property real latitude
        property real longitude

        PropertyAnimation {
            target: map
            property: "center.latitude"
            to: panAnimation.latitude
            easing.type: Easing.InOutCubic
            duration: 1000
        }

        PropertyAnimation {
            target: map
            property: "center.longitude"
            to: panAnimation.longitude
            easing.type: Easing.InOutCubic
            duration: 1000
        }
    }
}
