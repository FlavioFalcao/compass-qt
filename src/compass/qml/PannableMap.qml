/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.0
import QtMobility.location 1.1

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

        MapCircle {
            id: mapCircle

            color: "#40FF0000"
            border.color: Qt.darker(color)
            border.width: 3

            Behavior on center.latitude {
                PropertyAnimation { duration: 300 }
            }
            Behavior on center.longitude {
                PropertyAnimation { duration: 300 }
            }
            Behavior on radius {
                PropertyAnimation { duration: 300 }
            }
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
