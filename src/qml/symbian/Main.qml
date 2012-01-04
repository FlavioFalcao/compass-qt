/**
 * Copyright (c) 2012 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1

Window {
    id: window

    property alias myTools: toolBar.tools

    PageStack {
        id: pageStack

        anchors {
            top: statusBar.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Component.onCompleted: {
            pageStack.push(Qt.resolvedUrl("MapView.qml"));
        }
    }

    StatusBar {
        id: statusBar

        anchors.top: parent.top

        Text {
            id: titleId

            anchors {
                top: parent.top
                left: parent.left
                leftMargin: platformStyle.paddingSmall
            }

            font {
                family: platformStyle.fontFamilyRegular
                pixelSize: platformStyle.fontSizeMedium
            }

            color: platformStyle.colorNormalLight
            text: "Compass"
        }
    }

    // Custom toolbar for the pages
    CustomToolBar {
        id: toolBar

        anchors.bottom: parent.bottom
    }
}
