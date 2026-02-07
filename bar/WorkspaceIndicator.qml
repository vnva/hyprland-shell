import QtQuick
import Quickshell
import Quickshell.Hyprland

import ".." as Root

Item {
    id: workspaceRoot

    implicitWidth: row.implicitWidth
    implicitHeight: row.implicitHeight

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 4

        Repeater {
            model: Hyprland.workspaces

            delegate: Rectangle {
                required property var modelData

                width: modelData.focused ? 20 : 8
                height: 8
                radius: 4
                anchors.verticalCenter: parent.verticalCenter

                color: modelData.focused
                    ? Root.Theme.base0D
                    : Root.Theme.base03

                Behavior on color {
                    ColorAnimation { duration: Root.Theme.transitionDuration; easing.type: Easing.OutQuad }
                }

                Behavior on width {
                    NumberAnimation { duration: Root.Theme.transitionDuration; easing.type: Easing.OutQuad }
                }

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -4
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("workspace " + modelData.id)
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.NoButton
        onWheel: (event) => {
            if (event.angleDelta.y > 0) {
                Hyprland.dispatch("workspace e-1");
            } else {
                Hyprland.dispatch("workspace e+1");
            }
        }
    }
}
