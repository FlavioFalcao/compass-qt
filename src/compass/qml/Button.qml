import QtQuick 1.0

Item {
    id: button

    property bool upSideDown: false
    property alias text: text.text

    signal clicked()

    width: 70; height: 35

    Rectangle {
        anchors {
            fill: parent
            bottomMargin: button.upSideDown ? 0 : -10
            topMargin: button.upSideDown ? -10 : 0
        }

        gradient: upSideDown ? upSideDownGradient
                             : normalGradient

        Gradient {
            id: normalGradient

            GradientStop { position: 0.0; color: "#99505050" }
            GradientStop { position: 0.8; color: "#99000000" }
        }

        Gradient {
            id: upSideDownGradient

            GradientStop { position: 0.2; color: "#99000000" }
            GradientStop { position: 1.0; color: "#99505050" }
        }

        radius: 8
    }

    Text {
        id: text

        anchors.centerIn: parent
        font.bold: true
        font.pixelSize: 10
        style: Text.Raised
        styleColor: "gray"
        color: "white"
    }

    opacity: 0.8

    Behavior on scale { PropertyAnimation { duration: 50 } }

    MouseArea {
        anchors.fill: parent
        onClicked: button.clicked()
        onPressed: button.scale = 0.9
        onReleased: button.scale = 1.0
        scale: 2
    }
}
