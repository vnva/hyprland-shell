import QtQuick
import Quickshell

import ".." as Root

Text {
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "HH:mm") + " / " + Qt.formatDateTime(clock.date, "dd.MM")
    font.pixelSize: Root.Theme.fontSizePrimary
    font.family: "monospace"
    color: Root.Theme.base05
}
