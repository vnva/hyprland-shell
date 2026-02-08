import QtQuick
import Quickshell

import ".." as Root
import "../icons" as Icons

Row {
    spacing: Root.Theme.spacingUnit

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Icons.Icon {
        anchors.verticalCenter: parent.verticalCenter
        size: Root.Theme.fontSizePrimary
        name: "clock"
        color: Root.Theme.base05
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "HH:mm") + " / " + Qt.formatDateTime(clock.date, "dd.MM")
        font.family: Root.Theme.fontFamily
        font.pixelSize: Root.Theme.fontSizePrimary
        color: Root.Theme.base05
    }
}
