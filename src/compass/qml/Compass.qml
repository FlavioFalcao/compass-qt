import Qt 4.7
import QtWebKit 1.0

Item {
    id: ui

    property real northdeg: 45

    function handleAzimuth(azimuth, calLevel) {
        northdeg = -azimuth
    }

    function toggleMode() {
        if(state == "NavigationMode")
            state = "MapMode"
        else
            state = "NavigationMode"
    }

    width: 640; height: 360
    anchors.fill: parent
    Component.onCompleted: state = "NavigationMode"

    Flickable {
        anchors.fill: parent

        contentWidth: map.width
        contentHeight: map.height


        WebView {
            id: map

            width:  ui.width; height: ui.height
            url: "http://m.ovi.me/?i&c=62.2409558,25.7573819&h=" + 360 + "&w=" + 640 + "&z=15"
        }
    }

    Rectangle {
        id: mapHider
        anchors.fill: parent
        color: "#f8f8f0"
    }

    Image {
        id: compass

        y: 34
        width: 640; height: 292
        source: "images/Walkers_compass_transparent.png"
        fillMode: Image.PreserveAspectFit
        smooth: true

        MouseArea {
            id: compassRotateArea

            enabled: false

            property real centerx: width / 2
            property real centery: height / 2
            property int previousX: 0
            property int previousY: 0

            anchors.fill: parent

            onPressed: {
                previousX = mouse.x
                previousY = mouse.y
            }

            onPositionChanged: {
                var ax = mouse.x - centerx
                var ay = centery - mouse.y
                var bx = previousX - centerx
                var by = centery - previousY

                var angledelta = (Math.atan2(by, bx) - Math.atan2(ay, ax)) * 57.2957795
                if(angledelta > 180)       { angledelta -= 360 }
                else if(angledelta < -180) { angledelta += 360 }

                compass.rotation = (compass.rotation + angledelta) % 360
            }
        }

        MouseArea {
            id: compassMoveArea

            enabled: false
            anchors {
                fill: parent
                leftMargin: compass.width * 0.2
                rightMargin: compass.width * 0.3
            }

            drag.axis: Drag.XandYAxis
            drag.target: parent
        }

        Image {
            id: scale

            anchors {
                right: parent.right; rightMargin: parent.width * 0.157
                top: parent.top; bottom: parent.bottom
            }

            width: height

            source: "images/Scale.png"
            smooth: true

            MouseArea {
                property real centerx: width / 2
                property real centery: height / 2
                property int previousX: 0
                property int previousY: 0

                anchors.fill: parent

                onPressed: {
                    previousX = mouse.x
                    previousY = mouse.y
                }

                onDoubleClicked: RotationAnimation {
                    target: scale
                    property: "rotation"
                    to: -compass.rotation + 90
                    duration: 250
                    direction: RotationAnimation.Shortest
                }

                onPositionChanged: {
                    var ax = mouse.x - centerx
                    var ay = centery - mouse.y
                    var bx = previousX - centerx
                    var by = centery - previousY

                    var angledelta = (Math.atan2(by, bx) - Math.atan2(ay, ax)) * 57.2957795
                    if(angledelta > 180)       { angledelta -= 360 }
                    else if(angledelta < -180) { angledelta += 360 }

                    scale.rotation = (scale.rotation + angledelta) % 360
                }
            }
        }

        Image {
            id: needle

            anchors.centerIn: scale
            height: scale.paintedHeight * 0.63
            width: height * 0.209

            source: "images/compassneedle.png"
            smooth: true

            rotation: ui.northdeg - compass.rotation
            Behavior on rotation {
                RotationAnimation {
                    duration: 250
                    direction: RotationAnimation.Shortest
                }
            }
        }
    }

    Image {
        id: toggleButton
        anchors {
            right: parent.right; rightMargin: 5
            bottom: parent.bottom; bottomMargin: 5
        }

        opacity: 0.8
        source: ui.state == "MapMode" ? "images/iconcompass.png" : "images/iconovimaps.png"
        smooth: true

        Behavior on scale { PropertyAnimation { duration: 50 } }

        MouseArea {
            anchors.fill: parent
            onClicked: ui.toggleMode()
            onPressed: toggleButton.scale = 0.9
            onReleased: toggleButton.scale = 1.0
        }
    }

    Rectangle {

        anchors {
            right: parent.right; rightMargin: 5
            top: parent.top; topMargin: 5
        }
        color: "#303000"
        opacity: 0.8
        radius: 6

        width: 40; height: 40

        Image {
            id: closeButton

            anchors.centerIn: parent

            source: "images/exit.png"
            smooth: true

            Behavior on scale { PropertyAnimation { duration: 50 } }

            MouseArea {
                anchors.fill: parent
                onClicked: Qt.quit()
                onPressed: closeButton.scale = 0.9
                onReleased: closeButton.scale = 1.0
            }

        }
    }

    states: [ State {
            name: "MapMode"
            PropertyChanges { target: compass; width: 320; height: 146 }
            PropertyChanges { target: compassRotateArea; enabled: true }
            PropertyChanges { target: compassMoveArea; enabled: true }
            PropertyChanges { target: mapHider; opacity: 0 }
        },
        State {
            name: "NavigationMode"
            PropertyChanges { target: compass; rotation: 0; x: 0; y: 34; width: 640; height: 292 }
            PropertyChanges { target: compassRotateArea; enabled: false }
            PropertyChanges { target: compassMoveArea; enabled: false }
            PropertyChanges { target: mapHider; opacity: 0.95 }
        }
    ]

    transitions: Transition {
        PropertyAnimation {
            properties: "x,y,width,height,rotation,opacity"
            duration: 500
            easing.type: Easing.InOutCirc
        }

        RotationAnimation {
            property: "rotation"
            duration: 500
            easing.type: Easing.InOutCirc
            direction:  RotationAnimation.Shortest
        }
    }
}
