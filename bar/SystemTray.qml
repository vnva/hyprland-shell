import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

import ".." as Root
import "../icons" as Icons

Item {
    id: tray

    property PanelWindow panelWindow
    property Item sectionItem

    implicitWidth: button.width
    implicitHeight: button.height

    property bool popupOpen: false

    // Button
    Item {
        id: button
        width: icon.width
        height: icon.height
        anchors.centerIn: parent

        Icons.Icon {
            id: icon
            anchors.centerIn: parent
            size: Root.Theme.fontSizePrimary
            name: "chevron-down"
            color: tray.popupOpen ? Root.Theme.base0D : Root.Theme.base05

            Behavior on color {
                ColorAnimation { duration: Root.Theme.transitionDuration; easing.type: Easing.OutQuad }
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                tray.popupOpen = !tray.popupOpen;
            }
        }
    }

    PopupWindow {
        id: popup
        visible: tray.popupOpen

        anchor.item: tray.sectionItem
        anchor.margins.bottom: -Root.Theme.barMargin
        anchor.edges: Edges.Bottom | Edges.Right
        anchor.gravity: Edges.Bottom | Edges.Left

        color: "transparent"
        implicitWidth: popupContent.width
        implicitHeight: popupContent.height

        onVisibleChanged: {
            if (!visible) tray.popupOpen = false;
        }

        Rectangle {
            id: popupContent
            width: 200
            height: contentColumn.height + Root.Theme.sectionPadding * 2
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
                        color: itemMouse.containsMouse ? Root.Theme.base02 : "transparent"

                        Behavior on color {
                            ColorAnimation { duration: Root.Theme.transitionDuration; easing.type: Easing.OutQuad }
                        }

                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: Root.Theme.spacingUnit * 2
                            anchors.rightMargin: Root.Theme.spacingUnit * 2
                            spacing: Root.Theme.spacingUnit * 2

                            Image {
                                anchors.verticalCenter: parent.verticalCenter
                                source: trayItemDelegate.modelData.icon
                                width: 16
                                height: 16
                                sourceSize: Qt.size(16, 16)
                            }

                            Text {
                                anchors.verticalCenter: parent.verticalCenter
                                text: trayItemDelegate.modelData.title || trayItemDelegate.modelData.id
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
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
