import QtQuick 1.0
import "settings.js" as DB

Image {
    id: pane

    property bool autoNorthInMap
    property bool bearingTurnInTrackMode
    property int mapMode
    property bool screenSaverInhibited: false

    onAutoNorthInMapChanged: console.log("autoNorhInMap: " + autoNorthInMap)
    onBearingTurnInTrackModeChanged: console.log("bearingTurnInTrackMode " + bearingTurnInTrackMode)
    onMapModeChanged: console.log("mapMode " + mapMode)
    onScreenSaverInhibitedChanged: console.log("screenSaverInhibited " + screenSaverInhibited)

    source: "images/desk.png"
    width: 400; height: 300

    Component.onCompleted: {
        DB.resetDB()
        view.model = DB.readSettings()
    }

    Component {
        id: delegate

        Item {
            width: view.width; height: 50

            Text {
                id: nameText

                x: 10
                width: parent.width - x - 10
                text: name
                color: "white"
                wrapMode: Text.WordWrap
                font.bold: true
                font.pixelSize: 14
            }

            Text {
                id: valueText

                anchors {
                    top: nameText.bottom;
                    left: nameText.left
                }

                text: value
                color: "white"
                wrapMode: Text.WordWrap
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var item = view.model.get(index)
                    if(item.name == "MapMode") {

                    }
                    else {
                        if(item.value == 0) {
                            item.value = 1
                        }
                        else {
                            item.value = 0
                        }
                    }
                    // Not very pretty code here.. :|
                    DB.saveSetting(item.name, item.value)
                    DB.updateProperties(item)
                }
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
        delegate: delegate
        path: Path {
            startX: view.width / 2; startY:  0
            PathLine { x: view.width / 2; y: view.height }
        }
    }
}
