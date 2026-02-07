import Quickshell
import QtQuick

import "bar" as Bar

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar.Bar {
            required property var modelData
            screen: modelData
        }
    }

    Overview {}
}
