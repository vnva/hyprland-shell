pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    // Base16 palette
    readonly property color base00: _colors["base00"] ?? "#181818"
    readonly property color base01: _colors["base01"] ?? "#151515"
    readonly property color base02: _colors["base02"] ?? "#464646"
    readonly property color base03: _colors["base03"] ?? "#747474"
    readonly property color base04: _colors["base04"] ?? "#b9b9b9"
    readonly property color base05: _colors["base05"] ?? "#d0d0d0"
    readonly property color base06: _colors["base06"] ?? "#e8e8e8"
    readonly property color base07: _colors["base07"] ?? "#eeeeee"
    readonly property color base08: _colors["base08"] ?? "#fd886b"
    readonly property color base09: _colors["base09"] ?? "#fc4769"
    readonly property color base0A: _colors["base0A"] ?? "#fecb6e"
    readonly property color base0B: _colors["base0B"] ?? "#32ccdc"
    readonly property color base0C: _colors["base0C"] ?? "#acddfd"
    readonly property color base0D: _colors["base0D"] ?? "#20bcfc"
    readonly property color base0E: _colors["base0E"] ?? "#ba8cfc"
    readonly property color base0F: _colors["base0F"] ?? "#b15f4a"

    // Typography
    readonly property string fontFamily: _config["font"] ?? "Noto Sans"
    readonly property int fontSizePrimary: 12
    readonly property int fontSizeSecondary: 10

    // Layout
    readonly property int barHeight: 30
    readonly property int barMargin: 4
    readonly property int barRadius: 5
    readonly property int pillHeight: 28
    readonly property int pillRadius: 14
    readonly property int pillPadding: 12

    // Bar width (0 = full screen width)
    readonly property int barWidth: parseInt(_config["barWidth"] ?? "0") || 1950

    // Spacing (4px base unit)
    readonly property int spacingUnit: 4
    readonly property int sectionPadding: 10
    readonly property int widgetGap: 6

    // Glass
    readonly property real glassOpacity: 0.6
    readonly property real overviewGlassOpacity: 0.3

    // Transitions
    readonly property int transitionDuration: 150

    // Internal: parsed values from config file
    property var _colors: ({})
    property var _config: ({})

    FileView {
        id: colorsFile
        path: Quickshell.env("SOLID_SHELL_COLORS")
            || (Quickshell.env("HOME") + "/.config/hyprland-shell/colors.conf")
        blockLoading: true
        blockAllReads: false
        printErrors: false
    }

    function _parseConfig(text: string) {
        let colors = {};
        let config = {};
        let lines = text.split("\n");
        for (let i = 0; i < lines.length; i++) {
            let line = lines[i].trim();
            if (line === "" || line.startsWith("#")) continue;
            let colorMatch = line.match(/^(base[0-9A-Fa-f]{2})\s*:\s*"?(#[0-9A-Fa-f]{6})"?/);
            if (colorMatch) {
                colors[colorMatch[1]] = colorMatch[2];
                continue;
            }
            let kvMatch = line.match(/^(\w+)\s*:\s*"?([^"]+)"?\s*$/);
            if (kvMatch) {
                config[kvMatch[1]] = kvMatch[2].trim();
            }
        }
        _colors = colors;
        _config = config;
    }

    Component.onCompleted: {
        let content = colorsFile.text();
        if (content && content.length > 0) {
            _parseConfig(content);
        }
    }
}
