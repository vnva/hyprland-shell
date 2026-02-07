import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import ".." as Root

Rectangle {
    id: windowCard

    required property var modelData
    required property int workspaceId
    required property bool overviewVisible

    signal selected()

    width: parent?.width ?? 0
    height: cardContent.implicitHeight + 8
    radius: 8
    color: windowMouse.containsMouse
        ? Root.Theme.base02
        : Root.Theme.base01

    border.width: windowCard.modelData.activated ? 1 : 0
    border.color: Root.Theme.base0D

    MouseArea {
        id: windowMouse
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            Hyprland.dispatch("workspace " + windowCard.workspaceId);
            windowCard.modelData.wayland?.activate();
            windowCard.selected();
        }
    }

    Column {
        id: cardContent
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 4
        spacing: 6

        // Preview
        Rectangle {
            width: parent.width
            height: width * 0.56
            radius: 6
            color: Root.Theme.base00
            clip: true

            ScreencopyView {
                anchors.fill: parent
                captureSource: windowCard.modelData.wayland
                live: windowCard.overviewVisible
                paintCursor: false
            }

            // Active window badge
            Rectangle {
                visible: windowCard.modelData.activated
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 6
                width: 8
                height: 8
                radius: 4
                color: Root.Theme.base0D
            }
        }

        // Title row
        RowLayout {
            width: parent.width
            spacing: 6

            Text {
                Layout.fillWidth: true
                text: windowCard.modelData.title || "untitled"
                font.pixelSize: Root.Theme.fontSizePrimary
                font.family: "monospace"
                color: Root.Theme.base05
                elide: Text.ElideRight
            }

            // Close button
            Rectangle {
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                radius: 9
                color: closeMouse.containsMouse
                    ? Root.Theme.base09
                    : "transparent"
                opacity: windowMouse.containsMouse ? 1.0 : 0.0

                Text {
                    anchors.centerIn: parent
                    text: "\u00d7"
                    font.pixelSize: 14
                    color: closeMouse.containsMouse
                        ? Root.Theme.base07
                        : Root.Theme.base04
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: windowCard.modelData.wayland?.close()
                }
            }
        }
    }
}
