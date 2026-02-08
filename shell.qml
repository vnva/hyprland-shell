//@ pragma UseQApplication
import Quickshell
import QtQuick

import "bar" as Bar
import "overview" as Overview
import "lockscreen" as Lockscreen

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar.Bar {
            required property var modelData
            screen: modelData
        }
    }

    Overview.Overview {}
    Lockscreen.Lockscreen {}
}
