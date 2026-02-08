import QtQuick

import ".." as Root
import "../services" as Services
import "../icons" as Icons

Item {
    id: layoutIndicator

    implicitWidth: layoutRow.implicitWidth
    implicitHeight: layoutRow.implicitHeight

    Row {
        id: layoutRow
        anchors.centerIn: parent
        spacing: 4

        Icons.Icon {
            name: "keyboard"
            color: Root.Theme.base05
            size: Root.Theme.fontSizePrimary
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: layoutText
            text: Services.LayoutService.currentLayout || "EN"
            font.family: Root.Theme.fontFamily
            font.pixelSize: Root.Theme.fontSizePrimary
            color: Root.Theme.base05
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
