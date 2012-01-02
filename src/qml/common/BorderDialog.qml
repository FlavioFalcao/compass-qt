/*
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1

BorderImage {
    id: background

    property alias border: background.border

    // The heading item
    property alias heading: heading.children

    // The elements placed as children of container, will
    // actually be children of background
    default property alias children: centerArea.children

    anchors.fill: parent
    source: "../images/infoback.png"
    border {
        top: 71
        bottom: 10
        left: 10
        right: 10
    }

    Item {
        id: heading

        anchors {
            top: parent.top; topMargin: 15
            left: parent.left; leftMargin: 20
            right: parent.right; rightMargin: 20
        }

        height: 59
        clip: true
    }

    Item {
        id: centerArea

        anchors {
            fill: parent
            topMargin: 86
            bottomMargin: 15
            leftMargin: 20
            rightMargin: 20
        }

        clip: true
    }
}
