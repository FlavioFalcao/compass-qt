/**
 * Copyright (c) 2012 Nokia Corporation.
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
            bottom: parent.bottom
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

    ToolBarStyle {
        id: toolBarStyle

        background: "../images/harmattan_toolbar.png"
    }

    ToolBar {
        id: toolBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        platformStyle: toolBarStyle
    }
}
