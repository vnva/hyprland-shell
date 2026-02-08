import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.SystemTray

import ".." as Root
import "../icons" as Icons

PanelWindow {
    id: popup

    WlrLayershell.namespace: "hyprland-shell-bar"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    visible: false
    color: "transparent"

    property int barHeight: Root.Theme.barHeight
    property int barMargin: Root.Theme.barMargin
    property real rightSectionX: 0

    // Fill entire screen with transparent backdrop
    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    focusable: true

    onVisibleChanged: {
        if (visible) {
            keyHandler.forceActiveFocus();
        }
    }

    // Invisible item to capture keyboard focus
    Item {
        id: keyHandler
        anchors.fill: parent
        focus: true

        Keys.onPressed: (event) => {
            popup.visible = false;
            event.accepted = true;
        }
    }

    // Transparent backdrop - closes on click
    MouseArea {
        anchors.fill: parent
        onClicked: popup.visible = false
    }

    // Popup content positioned in top-right
    Rectangle {
        id: popupContent
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.topMargin: barHeight + barMargin * 2
        anchors.rightMargin: rightSectionX

        width: 200 + Root.Theme.sectionPadding * 2
        height: contentColumn.implicitHeight + Root.Theme.sectionPadding * 2

        radius: Root.Theme.barRadius
        color: Qt.rgba(
            Root.Theme.base00.r,
            Root.Theme.base00.g,
            Root.Theme.base00.b,
            Root.Theme.glassOpacity
        )

        Column {
            id: contentColumn
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: Root.Theme.sectionPadding

            // Empty state
            Text {
                visible: trayRepeater.count === 0
                width: contentColumn.width
                horizontalAlignment: Text.AlignHCenter
                text: "No tray items"
                font.family: Root.Theme.fontFamily
                font.pixelSize: Root.Theme.fontSizePrimary
                color: Root.Theme.base03
            }

            // Tray items
            Repeater {
                id: trayRepeater
                model: SystemTray.items

                delegate: Rectangle {
                    id: trayItemDelegate
                    required property var modelData
                    width: contentColumn.width
                    height: 28
                    radius: Root.Theme.barRadius
                    color: itemMouse.containsMouse
                        ? Qt.rgba(Root.Theme.base02.r, Root.Theme.base02.g, Root.Theme.base02.b, 0.5)
                        : "transparent"

                    Behavior on color {
                        ColorAnimation { duration: Root.Theme.transitionDuration; easing.type: Easing.OutQuad }
                    }

                    Row {
                        anchors.fill: parent
                        anchors.leftMargin: Root.Theme.spacingUnit
                        anchors.rightMargin: Root.Theme.spacingUnit
                        spacing: Root.Theme.spacingUnit + 2

                        Image {
                            anchors.verticalCenter: parent.verticalCenter
                            source: trayItemDelegate.modelData.icon
                            width: Root.Theme.fontSizePrimary + 1
                            height: Root.Theme.fontSizePrimary + 1
                            sourceSize: Qt.size(Root.Theme.fontSizePrimary + 1, Root.Theme.fontSizePrimary + 1)
                        }


                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            text: trayItemDelegate.modelData.tooltipTitle || trayItemDelegate.modelData.title || trayItemDelegate.modelData.id
                            font.family: Root.Theme.fontFamily
                            font.pixelSize: Root.Theme.fontSizePrimary
                            color: Root.Theme.base05
                            elide: Text.ElideRight
                            width: parent.width - 16 - Root.Theme.spacingUnit * 2
                        }
                    }

                    MouseArea {
                        id: itemMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton

                        onClicked: (mouse) => {
                            if ((mouse.button === Qt.RightButton || trayItemDelegate.modelData.onlyMenu)
                                    && trayItemDelegate.modelData.hasMenu) {
                                let pos = itemMouse.mapToItem(null, mouse.x, mouse.y);
                                trayItemDelegate.modelData.display(popup, pos.x, pos.y);
                            } else {
                                trayItemDelegate.modelData.activate();
                                popup.visible = false;  // Close after activation
                            }
                        }
                    }
                }
            }
        }
    }
}
