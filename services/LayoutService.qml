pragma Singleton

import QtQuick
import Quickshell.Hyprland

QtObject {
    id: layoutService

    property string currentLayout: ""

    function parseLayout(fullLayoutName) {
        if (!fullLayoutName) {
            currentLayout = ""
            return
        }

        const shortName = fullLayoutName.substring(0, 2).toUpperCase()
        if (currentLayout !== shortName) {
            currentLayout = shortName
        }
    }

    function handleRawEvent(event) {
        if (!event || event.name !== "activelayout") {
            return
        }

        const dataString = event.data
        if (!dataString) {
            currentLayout = ""
            return
        }

        const layoutInfo = dataString.split(",")
        const fullLayoutName = layoutInfo[layoutInfo.length - 1]
        parseLayout(fullLayoutName)
    }

    Component.onCompleted: {
        Hyprland.rawEvent.connect(handleRawEvent)
    }
}
