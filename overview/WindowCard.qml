import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland
import Quickshell.Wayland
import ".." as Root

Rectangle {
    id: windowCard

    required property var window
    required property bool selected
    required property real cardWidth
    required property real cardHeight
    required property bool overviewVisible

    signal activated()

    property bool hovered: cardHover.hovered

    width: cardWidth
    height: cardHeight + titleBar.height
    radius: 12
    color: selected
        ? Root.Theme.base02
        : hovered
            ? Qt.rgba(Root.Theme.base01.r, Root.Theme.base01.g, Root.Theme.base01.b, 0.9)
            : Qt.rgba(Root.Theme.base01.r, Root.Theme.base01.g, Root.Theme.base01.b, 0.5)

    border.width: selected ? 2 : 0
    border.color: Root.Theme.base0D

    // Hover tracking — passive, unaffected by child MouseAreas
    HoverHandler {
        id: cardHover
    }

    // Click — behind everything so closeMouse can intercept
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: windowCard.activated()
    }

    // Preview
    Rectangle {
        id: preview
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 4
        height: windowCard.cardHeight - 4
        radius: 10
        color: Root.Theme.base00
        clip: true

        ScreencopyView {
            anchors.fill: parent
            captureSource: windowCard.window.wayland
            live: windowCard.overviewVisible
            paintCursor: false
        }

        // Workspace badge — top right of preview
        Rectangle {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 6
            width: 22
            height: 18
            radius: 4
            color: Qt.rgba(Root.Theme.base00.r, Root.Theme.base00.g, Root.Theme.base00.b, 0.7)

            Text {
                anchors.centerIn: parent
                text: windowCard.window.workspace?.id ?? ""
                font.family: Root.Theme.fontFamily
                font.pixelSize: 10
                color: Root.Theme.base04
            }
        }

        // Active window dot — top left of preview
        Rectangle {
            visible: windowCard.window.activated
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 8
            width: 8
            height: 8
            radius: 4
            color: Root.Theme.base0D
        }
    }

    // Title bar
    Item {
        id: titleBar
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 32

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            spacing: 6

            Text {
                Layout.fillWidth: true
                text: windowCard.window.title || "untitled"
                font.family: Root.Theme.fontFamily
                font.pixelSize: Root.Theme.fontSizeSecondary
                color: windowCard.selected ? Root.Theme.base05 : Root.Theme.base04
                elide: Text.ElideRight
            }

            // Close button
            Rectangle {
                Layout.preferredWidth: 18
                Layout.preferredHeight: 18
                radius: 9
                color: closeMouse.containsMouse ? Root.Theme.base09 : "transparent"
                visible: windowCard.hovered || windowCard.selected

                Text {
                    anchors.centerIn: parent
                    text: "\u00d7"
                    font.family: Root.Theme.fontFamily
                    font.pixelSize: 13
                    color: closeMouse.containsMouse ? Root.Theme.base07 : Root.Theme.base04
                }

                MouseArea {
                    id: closeMouse
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: windowCard.window.wayland?.close()
                }
            }
        }
    }
}
