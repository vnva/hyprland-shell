import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

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
            Theme.base00.r,
            Theme.base00.g,
            Theme.base00.b,
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

                delegate: Column {
                    id: wsColumn
                    required property var modelData

                    width: Math.min(320, (content.width - (Hyprland.workspaces.values.length - 1) * 16) / Math.max(Hyprland.workspaces.values.length, 1))
                    spacing: 10
                    anchors.top: parent.top

                    // Workspace header
                    Rectangle {
                        width: parent.width
                        height: 32
                        radius: 6
                        color: wsColumn.modelData.focused
                            ? Qt.rgba(Theme.base0D.r, Theme.base0D.g, Theme.base0D.b, 0.15)
                            : Qt.rgba(Theme.base01.r, Theme.base01.g, Theme.base01.b, 0.5)

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
                                    ? Theme.base0D
                                    : Theme.base03
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: wsColumn.modelData.id
                                font.pixelSize: Theme.fontSizePrimary
                                font.family: "monospace"
                                font.weight: wsColumn.modelData.focused ? Font.Bold : Font.Normal
                                color: wsColumn.modelData.focused
                                    ? Theme.base0D
                                    : Theme.base04
                            }

                            // Window count
                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: "· " + wsColumn.modelData.toplevels.values.length
                                font.pixelSize: Theme.fontSizeSecondary
                                font.family: "monospace"
                                color: Theme.base03
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Hyprland.dispatch("workspace " + wsColumn.modelData.id);
                                overview.visible = false;
                            }
                        }
                    }

                    // Window cards
                    Flickable {
                        width: parent.width
                        height: workspacesRow.height - 32 - wsColumn.spacing
                        clip: true
                        contentHeight: windowColumn.implicitHeight
                        boundsBehavior: Flickable.StopAtBounds

                        Column {
                            id: windowColumn
                            width: parent.width
                            spacing: 8

                            Repeater {
                                model: wsColumn.modelData.toplevels

                                delegate: Rectangle {
                                    id: windowCard
                                    required property var modelData

                                    width: windowColumn.width
                                    height: cardContent.implicitHeight + 8
                                    radius: 8
                                    color: windowMouse.containsMouse
                                        ? Theme.base02
                                        : Theme.base01

                                    border.width: windowCard.modelData.activated ? 1 : 0
                                    border.color: Theme.base0D

                                    MouseArea {
                                        id: windowMouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            Hyprland.dispatch("workspace " + wsColumn.modelData.id);
                                            windowCard.modelData.wayland?.activate();
                                            overview.visible = false;
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
                                            color: Theme.base00
                                            clip: true

                                            ScreencopyView {
                                                anchors.fill: parent
                                                captureSource: windowCard.modelData.wayland
                                                live: overview.visible
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
                                                color: Theme.base0D
                                            }
                                        }

                                        // Title row
                                        RowLayout {
                                            width: parent.width
                                            spacing: 6

                                            Text {
                                                Layout.fillWidth: true
                                                text: windowCard.modelData.title || "untitled"
                                                font.pixelSize: Theme.fontSizePrimary
                                                font.family: "monospace"
                                                color: Theme.base05
                                                elide: Text.ElideRight
                                            }

                                            // Close button
                                            Rectangle {
                                                Layout.preferredWidth: 18
                                                Layout.preferredHeight: 18
                                                radius: 9
                                                color: closeMouse.containsMouse
                                                    ? Theme.base09
                                                    : "transparent"
                                                opacity: windowMouse.containsMouse ? 1.0 : 0.0

                                                Text {
                                                    anchors.centerIn: parent
                                                    text: "×"
                                                    font.pixelSize: 14
                                                    color: closeMouse.containsMouse
                                                        ? Theme.base07
                                                        : Theme.base04
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
                            }
                        }
                    }

                    // Empty state
                    Text {
                        visible: wsColumn.modelData.toplevels.values.length === 0
                        width: parent.width
                        horizontalAlignment: Text.AlignHCenter
                        text: "no windows"
                        font.pixelSize: Theme.fontSizeSecondary
                        font.family: "monospace"
                        color: Theme.base03
                        topPadding: 20
                    }
                }
            }
        }
    }
}
