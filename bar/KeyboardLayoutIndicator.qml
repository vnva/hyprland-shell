import QtQuick

import ".." as Root
import "../services" as Services

Item {
    id: layoutIndicator

    implicitWidth: layoutText.implicitWidth
    implicitHeight: layoutText.implicitHeight

    Text {
        id: layoutText
        anchors.centerIn: parent
        text: Services.LayoutService.currentLayout || "EN"
        font.family: Root.Theme.fontFamily
        font.pixelSize: Root.Theme.fontSizePrimary
        color: Services.LayoutService.currentLayout ? Root.Theme.base05 : Root.Theme.base03
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
