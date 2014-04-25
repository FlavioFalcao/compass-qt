/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.meego 1.0
import "../common"


CommonSettings {
    id: pane

    Image {
        id: mapStyleSetting

        height: 70
        source: "../images/harmattan_toolbar.png"

        anchors {
            bottom: parent.bottom; bottomMargin: 6
            left: parent.left
            right: parent.right
        }

        Label {
            id: mapStyleText

            anchors {
                left: parent.left; leftMargin: 30
                verticalCenter: parent.verticalCenter
            }

            text: "Satellite map"
        }

        Switch {
            id: satelliteMapSwitch

            anchors {
                centerIn: parent
                horizontalCenterOffset: 66
            }

            // Initial value
            checked: satelliteMap
            onCheckedChanged: { setSatelliteMap(checked); }
        }
    }

    Image {
        id: trackingSetting

        anchors {
            left: parent.left
            right: parent.right
            bottom: mapStyleSetting.top; bottomMargin: 6
        }

        source: "../images/harmattan_toolbar.png"
        height: 70

        Label {
            id: trackingText

            anchors {
                left: parent.left; leftMargin: 30
                verticalCenter: parent.verticalCenter
            }

            text: "Tracking"
        }

        Switch {
            id: trackingSwitch

            anchors {
                centerIn: parent
                horizontalCenterOffset: 66
            }

            checked: false
            onCheckedChanged: { setTracking(checked); }
        }

        ToolIcon {
            anchors {
                verticalCenter:  parent.verticalCenter
                right: parent.right
            }
            platformIconId: "toolbar-delete"
            onClicked: { clearRoute(); }
        }
    }
}
