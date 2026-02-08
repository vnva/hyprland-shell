import QtQuick
import Quickshell

import ".." as Root
import "../icons" as Icons

Row {
    spacing: 6

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    Icons.Icon {
        anchors.verticalCenter: parent.verticalCenter
        width: Root.Theme.fontSizePrimary
        height: Root.Theme.fontSizePrimary
        name: "clock"
        color: Root.Theme.base05
    }

    Text {
        anchors.verticalCenter: parent.verticalCenter
        text: Qt.formatDateTime(clock.date, "HH:mm") + " / " + Qt.formatDateTime(clock.date, "dd.MM")
        font.pixelSize: Root.Theme.fontSizePrimary
        color: Root.Theme.base05
    }
}
