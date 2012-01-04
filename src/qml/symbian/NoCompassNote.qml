/**
 * Copyright (c) 2011 Nokia Corporation.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "../common"

Page {
    id: page

    orientationLock: PageOrientation.LockPortrait

    tools: ToolBarLayout {
        ToolButton {
            iconSource: "toolbar-back"
            onClicked: {
                if (!page.pageStack.busy) {
                    page.pageStack.pop();
                }
            }
        }
    }

    BorderDialog {
        id: dialog

        anchors {
            fill: parent
            bottomMargin: page.tools.height
        }

        source: "../images/infoback_symbian.png"
        heading: Text {
            anchors.verticalCenter: parent.verticalCenter

            color: "#eea604"
            text: "<h2>Warning!</h2>"
            font.bold: true
            font.pixelSize: platformStyle.fontSizeLarge
        }

        Flickable {
            id: flickable

            anchors.fill: parent

            contentWidth: width
            contentHeight: infoText.height

            Text {
                id: infoText

                width: flickable.width
                color: "white"
                font.pixelSize: platformStyle.fontSizeMedium
                horizontalAlignment: Text.AlignJustify
                wrapMode: Text.Wrap
                text: "<p><b>The application failed to start the compass " +
                      "sensor.</b> This may indicate that your device has not " +
                      "been equipped with the magnetometer hardware sensor " +
                      "required by the compass feature.</p>" +
                      "<p>You can still use the map and location features of " +
                      "the application but the compass will not " +
                      "function properly, i.e. the compass does not give the " +
                      "correct bearing.</p>";
            }
        }
    }
}
