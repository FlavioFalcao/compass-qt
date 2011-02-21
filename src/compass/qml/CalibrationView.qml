import Qt 4.7
import CustomElements 1.0

Rectangle {
    id: view

    property real calibrationLevel: 0

    width: 640; height: 360

    Image {
        id: scale

        anchors.right: parent.right
        width: height; height: parent.height
        source: "images/Scale.png"
        smooth: true
        rotation: 90
    }

    Image {
        anchors.centerIn: scale

        width: height * 0.209; height: scale.paintedHeight * 0.63
        source: "images/compassneedle.png"
        rotation: calibrationLevel * 360

        Behavior on rotation { PropertyAnimation { duration: 1000 } }
    }

    Arc {
        anchors.fill: scale
        anchors.margins: 80

        opacity: 0.3
        color: "yellow"
        penWidth: 40
        startAngle: 90 * 16
        spanAngle: -view.calibrationLevel * 360 * 16

        Behavior on spanAngle { PropertyAnimation { duration: 1000 } }
    }


    Item {
        anchors {
            left: parent.left
            right: scale.left
            top: parent.top
            bottom: parent.bottom
        }

        Text {
            anchors.centerIn: parent

            text: "8"
            rotation: 90
            font.pixelSize: 90
        }
    }
}
