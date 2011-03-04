import QtQuick 1.0
import QtMobility.location 1.1

Item {
    id: mapholder

    property alias zoomLevel: map.zoomLevel
    property alias mapCenter: map.center
    property alias mapType: map.mapType
    property alias hereCenter: mapCircle.coordinate

    Map {
        id: map

        anchors.centerIn: parent
        width: parent.width * 2
        height: parent.height * 2

        plugin : Plugin { name : "nokia" }
        size.width: parent.width * 2
        size.height: parent.height * 2
        zoomLevel: 14
        connectivityMode: Map.OnlineMode
        smooth: true

        MapImage {
            id: mapCircle

            source: "images/here.png"
        }
    }

    MouseArea {
        anchors.fill: parent

        property bool mouseDown: false
        property int lastX: -1
        property int lastY: -1

        enabled: ui.state == "MapMode"

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
}
