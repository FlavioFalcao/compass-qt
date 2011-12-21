/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1

Item {
    id: container

    property bool shown: false
    property bool portrait
    property alias border: background.border

    // The elements placed as children of container, will
    // actually be children of background
    default property alias children: background.children

    width: 500; height: 300

    BorderImage {
        id: background

        anchors.centerIn: parent
        width: container.portrait ? container.width : container.height
        height: container.portrait ? container.height : container.width

        rotation: container.portrait ? 0 : 90
        opacity: container.shown ? 1.0 : 0.0

        Behavior on width { PropertyAnimation { duration: 400 } }
        Behavior on height { PropertyAnimation { duration: 400 } }
        Behavior on rotation {
            RotationAnimation {
                direction: RotationAnimation.Shortest
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }

        Behavior on opacity { PropertyAnimation { duration: 150 } }

        source: "images/infoback.png"

        border.top: 90
        border.bottom: 35
        border.left: 35
        border.right: 35
    }
}
