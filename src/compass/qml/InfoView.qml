import QtQuick 1.0

BorderImage {
    id: background

    property bool shown: false

    opacity: shown ? 1.0 : 0.0
    Behavior on opacity { PropertyAnimation { duration: 250 } }

    width: 500; height: 300
    source: "images/infoback.png"

    border.top: 90
    border.bottom: 70
    border.left: 35
    border.right: 100

    Text {
        x: 35; y: 45
        color: "#eea604"
        text: "Compass application v0.1.0"
        font.bold: true
        font.pixelSize: 20
    }

    Flickable {
        id: flickable

        anchors {
            fill: parent
            leftMargin: background.border.left
            rightMargin: 30
            topMargin: background.border.top
            bottomMargin: background.border.bottom
        }

        contentWidth: width
        contentHeight: infoText.height
        clip: true

        Text {
            id: infoText

            width: flickable.width
            color: "white"
            text: "Compass is an application that teaches the use of " +
                  "traditional compass and allows the user to have a bearing " +
                  "to the desired place using the Ovi maps."
            wrapMode: Text.WordWrap
        }
    }

    Item {

        anchors {
            right: parent.right; rightMargin: 27
            bottom: parent.bottom; bottomMargin: 27
        }

        width: 70; height: 40

        Text {
            anchors.centerIn: parent
            text: "Close"
            color: "#eea604"
            font.bold: true
            font.pixelSize: 15
        }

        MouseArea {
            anchors.fill: parent
            onClicked: background.shown = false
        }
    }
}
