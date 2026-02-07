import QtQuick
import Quickshell.Hyprland
import ".." as Root

Column {
    id: wsColumn

    required property var modelData
    required property real columnWidth
    required property real availableHeight
    required property bool overviewVisible

    signal selected()

    width: columnWidth
    spacing: 10
    anchors.top: parent?.top

    // Workspace header
    Rectangle {
        width: parent.width
        height: 32
        radius: 6
        color: wsColumn.modelData.focused
            ? Qt.rgba(Root.Theme.base0D.r, Root.Theme.base0D.g, Root.Theme.base0D.b, 0.15)
            : Qt.rgba(Root.Theme.base01.r, Root.Theme.base01.g, Root.Theme.base01.b, 0.5)

        Row {
            anchors.centerIn: parent
            spacing: 8

            // Active dot
            Rectangle {
                anchors.verticalCenter: parent.verticalCenter
                width: 6
                height: 6
                radius: 3
                color: wsColumn.modelData.focused
                    ? Root.Theme.base0D
                    : Root.Theme.base03
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: wsColumn.modelData.id
                font.pixelSize: Root.Theme.fontSizePrimary
                font.family: "monospace"
                font.weight: wsColumn.modelData.focused ? Font.Bold : Font.Normal
                color: wsColumn.modelData.focused
                    ? Root.Theme.base0D
                    : Root.Theme.base04
            }

            // Window count
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: "\u00b7 " + wsColumn.modelData.toplevels.values.length
                font.pixelSize: Root.Theme.fontSizeSecondary
                font.family: "monospace"
                color: Root.Theme.base03
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                Hyprland.dispatch("workspace " + wsColumn.modelData.id);
                wsColumn.selected();
            }
        }
    }

    // Window cards
    Flickable {
        width: parent.width
        height: wsColumn.availableHeight - 32 - wsColumn.spacing
        clip: true
        contentHeight: windowColumn.implicitHeight
        boundsBehavior: Flickable.StopAtBounds

        Column {
            id: windowColumn
            width: parent.width
            spacing: 8

            Repeater {
                model: wsColumn.modelData.toplevels

                delegate: WindowCard {
                    workspaceId: wsColumn.modelData.id
                    overviewVisible: wsColumn.overviewVisible
                    onSelected: wsColumn.selected()
                }
            }
        }
    }

    // Empty state
    Text {
        visible: wsColumn.modelData.toplevels.values.length === 0
        width: parent.width
        horizontalAlignment: Text.AlignHCenter
        text: "no windows"
        font.pixelSize: Root.Theme.fontSizeSecondary
        font.family: "monospace"
        color: Root.Theme.base03
        topPadding: 20
    }
}
