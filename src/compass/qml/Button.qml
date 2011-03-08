import QtQuick 1.0

Item {
    id: button

    property bool portrait: false
    property alias text: text.text
    property color buttonColor: "#80000000"
    property alias icon: icon.source

    signal clicked()

    width: 60; height: 60

    Rectangle {
        anchors {
            fill: parent
            rightMargin: -10
        }

        radius: 8
        smooth: true
        gradient: normalGradient

        Gradient {
            id: normalGradient

            GradientStop { position: 0.0; color: Qt.lighter(button.buttonColor, 1.8) }
            GradientStop { position: 0.8; color: button.buttonColor }
        }
    }

    Image {
        id: icon

        anchors.centerIn: parent

        rotation: button.portrait ? -90 : 0
        Behavior on rotation {
            RotationAnimation {
                duration: 100
                direction: RotationAnimation.Shortest
            }
        }
    }

    Text {
        id: text

        anchors.centerIn: parent

        font.bold: true
        font.pixelSize: 10
        style: Text.Raised
        styleColor: "black"
        color: "white"
        rotation: button.portrait ? -90 : 0
        Behavior on rotation {
            RotationAnimation {
                duration: 100
                direction: RotationAnimation.Shortest
            }
        }
    }

    opacity: 0.8

    Behavior on scale { PropertyAnimation { duration: 50 } }

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
        onPressed: button.scale = 0.9
        onReleased: button.scale = 1.0
        scale: 1.5
    }
}
