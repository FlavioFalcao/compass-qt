/**
 * Copyright (c) 2012-2014 Microsoft Mobile.
 */

import QtQuick 1.1
import com.nokia.symbian 1.1
import "../common"


CommonSettings {
    id: pane

    onOpacityChanged: {
        // Work-around for
        // https://bugreports.qt.nokia.com/browse/QTCOMPONENTS-1178
        if (opacity == 1.0) {
            // SettingsPane is now visible, update all button rows
            if (satelliteMap) {
                mapTypeButtonRow.checkedButton = mapTypeSatelliteMapDay;
            }
            else {
                mapTypeButtonRow.checkedButton = mapTypeStreetMap;
            }

            if (pane.screenSaverInhibited) {
                screenTimeoutButtonRow.checkedButton = screenTimeoutOn;
            }
            else {
                screenTimeoutButtonRow.checkedButton = screenTimeoutOff;
            }

            // The tracking is always defaultly off
            if (pane.trackingOn) {
                trackingButtonRow.checkedButton = trackingOn;
            }
            else {
                trackingButtonRow.checkedButton = trackingOff;
            }
        }
    }

    Image {
        id: screenLockSetting

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.horizontalCenter; rightMargin: 4
        }

        height: 80
        source: "../images/symbian_toolbar.png"

        Text {
            id: screenTimeoutText

            x: 5; y: 5
            font.pointSize: 5
            color: "white"
            text: "Screen timeout";
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: screenTimeoutButtonRow

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.right; rightMargin: 12
            }

            exclusive: true

            Button {
                id: screenTimeoutOn

                checkable: true
                text: "On"
                onClicked: { setScreenSaverInhibiter(true); }
            }

            Button {
                id: screenTimeoutOff

                checkable: true
                text: "Off"
                onClicked: { setScreenSaverInhibiter(false); }
            }
        }
    }

    Image {
        id: mapStyleSetting

        anchors {
            bottom: parent.bottom
            left: parent.horizontalCenter; leftMargin: 4
            right: parent.right
        }

        height: 80
        source: "../images/symbian_toolbar.png"

        Text {
            id: mapStyleText

            x: 5; y: 5
            font.pointSize: 5
            color: "white"
            text: "Map style"
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: mapTypeButtonRow

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.right; rightMargin: 12
            }

            exclusive: true

            Button {
                id: mapTypeStreetMap

                checkable: true
                text: "Street"
                onClicked: { setSatelliteMap(false); }
            }

            Button {
                id: mapTypeSatelliteMapDay

                checkable: true
                text: "Sat"
                onClicked: { setSatelliteMap(true); }
            }
        }
    }

    Image {
        id: trackingSetting

        anchors {
            left: parent.left
            right: parent.right
            bottom: screenLockSetting.top; bottomMargin: 10
        }

        height: 80
        source: "../images/symbian_toolbar.png"

        Text {
            id: trackingText

            x: 5; y: 5
            font.pointSize: 5
            color: "white"
            text: "Tracking"
            style: Text.Raised
            styleColor: "gray"
        }

        ButtonRow {
            id: trackingButtonRow

            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.horizontalCenter; rightMargin: 12 + 4
            }

            checkedButton: trackingOff

            Button {
                id: trackingOn

                text: "On"
                onClicked: { setTracking(true); }
            }

            Button {
                id: trackingOff

                text: "Off"
                onClicked: { setTracking(false); }
            }
        }

        Button {
            anchors {
                verticalCenter: parent.verticalCenter
                verticalCenterOffset: 10
                right: parent.right; rightMargin: 44
            }

            text: "Clear"
            onClicked: { clearRoute(); }
        }
    }
}
