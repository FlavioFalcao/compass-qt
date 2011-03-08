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
        /*
        console.log("Adding route to map")
        var coordinate = Qt.createQmlObject('import QtQuick 1.0; import QtMobility.location 1.1; Coordinate {}', route);
        coordinate.latitude = latitude
        coordinate.longitude = longitude
        */
    }

    Map {
        id: map

        anchors.centerIn: parent
        width: parent.width; height: parent.height
        size.width: width; size.height: height

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

            Behavior on center.latitude { PropertyAnimation { duration: 300 } }
            Behavior on center.longitude { PropertyAnimation { duration: 300 } }
            Behavior on radius { PropertyAnimation { duration: 300 } }
        }

        MapPolyline {
            id: route

            border.color: "blue"

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
}
