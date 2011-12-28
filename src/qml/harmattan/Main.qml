/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.meego 1.0

Window {
    id: window

    PageStack {
        id: pageStack

        anchors {
            top: statusBar.bottom
            left: parent.left
            right: parent.right
            bottom: toolBar.top
        }

        toolBar: toolBar

        Component.onCompleted: {
            pageStack.push(Qt.resolvedUrl("MapView.qml"));
        }
    }

    StatusBar {
        id: statusBar

        anchors.top: parent.top
    }

    ToolBar {
        id: toolBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }


    }
}
