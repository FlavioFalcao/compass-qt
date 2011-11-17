/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import QtMobility.location 1.2

Item {
    id: mapholder

    property alias zoomLevel: map.zoomLevel
    property alias mapCenter: map.center
    property bool satelliteMap: false
    property alias hereCenter: mapCircle.center
    property alias hereAccuracy: mapCircle.radius
    property alias panEnable: panMouseArea.enabled

    function addRoute(latitude, longitude) {
        // At the moment it is not possible to draw route on top of the map
        // dynamically
    }

    function moveHereToCoordinate(latitude, longitude, accuracyInMeters) {
        hereCenterAnimation.latitude = latitude
        hereCenterAnimation.longitude = longitude
        hereCenterAnimation.accuracyInMeters = accuracyInMeters
        hereCenterAnimation.restart()
    }

    function panToCoordinate(coordinate) {
        panAnimation.latitude = coordinate.latitude
        panAnimation.longitude = coordinate.longitude
        panAnimation.restart()
    }

    Map {
        id: map

        anchors.fill: parent
        size.width: height; size.height: width

        plugin : Plugin { name : "nokia" }
        zoomLevel: 14
        connectivityMode: Map.OnlineMode
        mapType: mapholder.satelliteMap ? Map.SatelliteMapDay
                                        : Map.StreetMap

        center: Coordinate {
            latitude: 62.2410021
            longitude: 25.7573175
        }

        MapCircle {
            id: mapCircle

            center: Coordinate {
                latitude: 62.2410021
                longitude: 25.7573175
            }

            color: "#40FF0000"
            border.color: Qt.darker(color)
            border.width: 3
        }
    }

    MouseArea {
        id: panMouseArea

        anchors.fill: parent

        property bool mouseDown: false
        property int lastX: -1
        property int lastY: -1

        hoverEnabled: true

        onPressed: {
            panAnimation.stop();
            mouseDown = true
            lastX = mouse.x
            lastY = mouse.y
        }

        onReleased: {
            mouseDown = false
            lastX = -1
            lastY = -1
        }

        onPositionChanged: {
            if (mouseDown) {
                var dx = mouse.x - lastX
                var dy = mouse.y - lastY
                map.pan(-dx, -dy)
                lastX = mouse.x
                lastY = mouse.y
            }
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
