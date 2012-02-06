/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import QtMobility.location 1.2
import "RouteScript.js" as RouteScript

Item {
    id: pannableMap

    property alias zoomLevel: map.zoomLevel
    property alias mapCenter: map.center
    property bool satelliteMap: false
    property alias hereCenter: mapCircle.center
    property alias hereAccuracy: mapCircle.radius
    property alias mapElement: map

    /*
      Adds a coordinate to the walked route. The coordinate holds the coordinate
      of the route. Parameter newRoute defines if the coordinate if the first
      point of a new route (true) or the point should be added to existing
      route (false).
    */
    function addRoutePoint(coordinate, newRoute) {
        if (newRoute === true || RouteScript.currentRoute === null) {
            RouteScript.currentRoute = lineComponent.createObject(null);
            RouteScript.currentRoute.border.color = "red"
            RouteScript.currentRoute.border.width = 2
            map.addMapObject(RouteScript.currentRoute);

            RouteScript.routes.push(RouteScript.currentRoute);
        }

        RouteScript.currentRoute.addCoordinate(coordinate);
    }

    /*!
      Helper function used by the Qt code when the stored route is loaded
      and shown on the Map. It is not possible to create instances of
      Coordinate elements in Qt, so we use Coordinate template.
    */
    function addRoutePointHelper(longitude, latitude, newRoute) {
        coordinateTemplate.latitude = latitude;
        coordinateTemplate.longitude = longitude;

        // coordinateTemplate is used to construct Coordinate element.
        addRoutePoint(coordinateTemplate, newRoute);
    }

    /*
      Clears the walked route.
    */
    function clearRoute() {
        while (RouteScript.routes.length > 0) {
            var mapPolyLine = RouteScript.routes.pop();
            map.removeMapObject(mapPolyLine);
            mapPolyLine.destroy();
        }

        RouteScript.route = null;
    }

    /*!
      Moves the red circle to given coordinate, sets the radius of the circle
      by the given accuracy. The movement of the circle will be animated if the
      parameter animate is true.
    */
    function moveHereToCoordinate(coordinate, accuracyInMeters, animate) {
        if (animate) {
            hereCenterAnimation.latitude = coordinate.latitude;
            hereCenterAnimation.longitude = coordinate.longitude;
            hereCenterAnimation.accuracyInMeters = accuracyInMeters;
            hereCenterAnimation.restart();
        }
        else {
            mapCircle.center.longitude = coordinate.longitude;
            mapCircle.center.latitude = coordinate.latitude;
            mapCircle.radius = accuracyInMeters;
        }
    }

    /*!
      Pans the map to the given coordinate.
    */
    function panToCoordinate(coordinate) {
        panAnimation.latitude = coordinate.latitude;
        panAnimation.longitude = coordinate.longitude;
        panAnimation.restart();
    }

    /*!
      Component allowing creation of MapPolyLines dynamically.
    */
    Component {
        id: lineComponent

        MapPolyline { }
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

        MapImage {
            id: mapImage

            coordinate: mapCircle.center
            source: "../images/hereicon.png"
            smooth: true
            offset.x: -10
            offset.y: -10
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
