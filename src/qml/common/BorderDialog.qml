/**
 * Copyright (c) 2012 Nokia Corporation.
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
    border {
        top: 70
        bottom: 0
        left: 0
        right: 0
    }

    Item {
        id: heading

        anchors {
            top: parent.top; topMargin: 6
            left: parent.left; leftMargin: 15
            right: parent.right; rightMargin: 15
        }

        height: 46
        clip: true
    }

    Item {
        id: centerArea

        anchors {
            fill: parent
            topMargin: 65
            bottomMargin: 3
            leftMargin: 15
            rightMargin: 15
        }

        clip: true
    }
}
