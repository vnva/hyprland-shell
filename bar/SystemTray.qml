import QtQuick
import Quickshell

import ".." as Root
import "../icons" as Icons

Item {
    id: tray

    property var trayPopup: null

    implicitWidth: button.width
    implicitHeight: button.height

    // Button
    Item {
        id: button
        width: icon.width
        height: icon.height
        anchors.centerIn: parent

        Icons.Icon {
            id: icon
            anchors.centerIn: parent
            size: Root.Theme.fontSizePrimary
            name: "chevron-down"
            color: (tray.trayPopup && tray.trayPopup.visible) ? Root.Theme.base0D : Root.Theme.base05

            Behavior on color {
                ColorAnimation { duration: Root.Theme.transitionDuration; easing.type: Easing.OutQuad }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                if (tray.trayPopup) {
                    tray.trayPopup.visible = !tray.trayPopup.visible;
                }
            }
        }
    }
}
