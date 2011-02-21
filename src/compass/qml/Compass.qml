import Qt 4.7

Image {
    id: compass

    property alias movable: compassMoveArea.enabled
    property alias rotable: compassRotateArea.enabled

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
            leftMargin: compass.width * 0.15
            rightMargin: compass.width * 0.3
        }

        drag.axis: Drag.XandYAxis
        drag.minimumX: -compass.width * 0.5
        drag.minimumY: -compass.height * 0.5
        drag.maximumX: ui.width - compass.width * 0.5
        drag.maximumY: ui.height - compass.height * 0.5
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
