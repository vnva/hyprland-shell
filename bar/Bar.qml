import Quickshell
import QtQuick
import QtQuick.Layouts

import ".." as Root

PanelWindow {
    id: bar

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
        0.85
    )

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Root.Theme.barMargin
        anchors.rightMargin: Root.Theme.barMargin
        anchors.topMargin: Root.Theme.barMargin
        spacing: Root.Theme.barMargin

        // Left
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: leftContent.implicitWidth + Root.Theme.sectionPadding * 2
            radius: Root.Theme.barRadius
            color: bar.glassColor

            WorkspaceIndicator {
                id: leftContent
                anchors.centerIn: parent
            }
        }

        Item { Layout.fillWidth: true }

        // Center
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: centerContent.implicitWidth + Root.Theme.sectionPadding * 2
            radius: Root.Theme.barRadius
            color: bar.glassColor

            Clock {
                id: centerContent
                anchors.centerIn: parent
            }
        }

        Item { Layout.fillWidth: true }

        // Right
        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: rightContent.implicitWidth + Root.Theme.sectionPadding * 2
            radius: Root.Theme.barRadius
            color: bar.glassColor
        }
    }

    Item { id: rightContent; implicitWidth: 60 }
}
