import Qt 4.7

Rectangle {
    id: pane

    width: 100; height: 200
    radius: 10
    color: "gray"
    border.width: 4
    border.color: "#202020"

    Text {
        anchors.centerIn: parent
        rotation: -90
        text: "Settings"
        color: "white"
    }
}
