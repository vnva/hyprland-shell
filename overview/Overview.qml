import QtQuick
import Quickshell
import Quickshell.Hyprland
import ".." as Root

PanelWindow {
    id: overview

    visible: false
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    focusable: true

    function toggle() {
        visible = !visible;
    }

    GlobalShortcut {
        appid: "solid-shell"
        name: "overview"
        description: "Toggle window overview"
        onPressed: overview.toggle()
    }

    Shortcut {
        sequence: "Escape"
        onActivated: overview.visible = false
    }

    // Backdrop — click empty area to close
    Rectangle {
        id: backdrop
        anchors.fill: parent
        color: Qt.rgba(
            Root.Theme.base00.r,
            Root.Theme.base00.g,
            Root.Theme.base00.b,
            0.88
        )

        MouseArea {
            anchors.fill: parent
            onClicked: overview.visible = false
        }
    }

    // Content
    Item {
        id: content
        anchors.fill: parent
        anchors.margins: 40

        // Workspace columns
        Row {
            id: workspacesRow
            anchors.top: parent.top
            anchors.topMargin: 24
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            Repeater {
                model: Hyprland.workspaces

                delegate: WorkspaceColumn {
                    columnWidth: Math.min(320, (content.width - (Hyprland.workspaces.values.length - 1) * 16) / Math.max(Hyprland.workspaces.values.length, 1))
                    availableHeight: workspacesRow.height
                    overviewVisible: overview.visible
                    onSelected: overview.visible = false
                }
            }
        }
    }
}
