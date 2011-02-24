import QtQuick 1.0

Rectangle {
    id: pane

    width: 640 * 0.2; height: 360
    radius: 8
    color: "darkgray"
    border.color: "black"
    border.width: 2

    gradient: Gradient {
        GradientStop { color: "#AAAAAA"; position: 0.0 }
        GradientStop { color: "#EEEEEE"; position: 0.4 }
        GradientStop { color: "#EEEEEE"; position: 0.6 }
        GradientStop { color: "#AAAAAA"; position: 1.0 }
    }

    Text {
        id: settingsText

        anchors {
            verticalCenter: parent.verticalCenter
        }
        rotation: -90
        text: "Settings"
        color: "white"
        font.pixelSize: 16
        font.bold: true
    }


    ListModel {
        id: settingsModel

        ListElement {
            name: "Map mode"
            value: 0 // 0 = Map.StreetMap
                     // 1 = Map.SatelliteMapDay
                     // 2 = Map.SatelliteMapNight
                     // 3 = Map.TerrainMap
        }

        ListElement {
            name: "Auto-north in map mode"
            value: 0 // 0 = false
                     // 1 = true
        }

        ListElement {
            name: "Enable scale turn in navigation mode"
            value: 0 // 0 = false
                     // 1 = true
        }

        ListElement {
            name: "Screensaver prohibited"
            value: 0 // 0 = not prohibited
                     // 1 = prohibited
        }
    }

    Component {
        id: delegate

        Item {
            width: view.width; height: 150

            Text {
                id: nameText

                x: settingsText.width - 10

                width: parent.width - x - 10
                text: name
                color: "black"
                wrapMode: Text.WordWrap
                font.pixelSize: 14
            }

            Text {
                id: valueText

                anchors {
                    top: nameText.bottom;
                    left: nameText.left
                }


                text: value
                color: "gray"
                wrapMode: Text.WordWrap
            }
        }
    }

    PathView {
        id: view

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }

        offset: 20

        model: settingsModel
        delegate: delegate
        path: Path {
            startX: view.width / 2; startY:  0
            PathLine { x: view.width / 2; y: view.height }
        }
    }
}
