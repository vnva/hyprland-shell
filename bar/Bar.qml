import Quickshell
import Quickshell.Wayland
import QtQuick

import ".." as Root

PanelWindow {
    id: bar

    WlrLayershell.namespace: "hyprland-shell-bar"

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Root.Theme.barHeight
    color: "transparent"

    property color glassColor: Qt.rgba(
        Root.Theme.base00.r,
        Root.Theme.base00.g,
        Root.Theme.base00.b,
        Root.Theme.glassOpacity
    )

    Item {
        id: container
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        implicitWidth: Root.Theme.barWidth > 0 ? Math.min(parent.width, Root.Theme.barWidth) : parent.width

        // Left
        Rectangle {
            anchors.left: parent.left
            anchors.leftMargin: Root.Theme.barMargin
            anchors.top: parent.top
            anchors.topMargin: Root.Theme.barMargin
            anchors.bottom: parent.bottom
            implicitWidth: leftContent.implicitWidth + Root.Theme.sectionPadding * 2
            radius: Root.Theme.barRadius
            color: bar.glassColor

            WorkspaceIndicator {
                id: leftContent
                anchors.centerIn: parent
            }
        }

        // Center
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: Root.Theme.barMargin
            anchors.bottom: parent.bottom
            implicitWidth: centerContent.implicitWidth + Root.Theme.sectionPadding * 2
            radius: Root.Theme.barRadius
            color: bar.glassColor

            Clock {
                id: centerContent
                anchors.centerIn: parent
            }
        }

        // Right
        Rectangle {
            id: rightSection
            anchors.right: parent.right
            anchors.rightMargin: Root.Theme.barMargin
            anchors.top: parent.top
            anchors.topMargin: Root.Theme.barMargin
            anchors.bottom: parent.bottom
            implicitWidth: rightContent.implicitWidth + Root.Theme.sectionPadding * 2
            radius: Root.Theme.barRadius
            color: bar.glassColor

            Row {
                id: rightContent
                anchors.centerIn: parent
                spacing: Root.Theme.spacingUnit * 2

                SystemTray {
                    anchors.verticalCenter: parent.verticalCenter
                    trayPopup: trayPopup
                }

                KeyboardLayoutIndicator {}
            }
        }
    }

    TrayPopup {
        id: trayPopup
        rightSectionX: {
            // Calculate distance from right edge of screen to right section
            let screenW = bar.screen.width;
            let containerW = container.width;
            let containerOffset = (screenW - containerW) / 2;
            return containerOffset + Root.Theme.barMargin;
        }
    }
}
