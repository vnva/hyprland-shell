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

    // Left
    Rectangle {
        anchors.left: parent.left
        anchors.leftMargin: Root.Theme.barMargin
        anchors.top: parent.top
        anchors.topMargin: Root.Theme.barMargin
        anchors.bottom: parent.bottom
        width: leftContent.implicitWidth + Root.Theme.sectionPadding * 2
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
        width: centerContent.implicitWidth + Root.Theme.sectionPadding * 2
        radius: Root.Theme.barRadius
        color: bar.glassColor

        Clock {
            id: centerContent
            anchors.centerIn: parent
        }
    }

    // Right
    Rectangle {
        anchors.right: parent.right
        anchors.rightMargin: Root.Theme.barMargin
        anchors.top: parent.top
        anchors.topMargin: Root.Theme.barMargin
        anchors.bottom: parent.bottom
        width: 60 + Root.Theme.sectionPadding * 2
        radius: Root.Theme.barRadius
        color: bar.glassColor
    }
}
