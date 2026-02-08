import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import ".." as Root

PanelWindow {
    id: overview

    WlrLayershell.namespace: "solid-shell-overview"

    visible: false
    color: "transparent"

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    exclusionMode: ExclusionMode.Ignore
    focusable: true

    property bool searching: searchInput.text !== ""
    property string searchText: searchInput.text.toLowerCase()
    property int selectedIndex: 0

    property var displayedWindows: {
        let all = Hyprland.toplevels.values;
        if (!searching) return all;
        let q = searchText;
        return all.filter(t => {
            let title = (t.title ?? "").toLowerCase();
            let appId = (t.wayland?.appId ?? "").toLowerCase();
            return title.includes(q) || appId.includes(q);
        });
    }

    // Grid sizing — fit cards to available space
    property real gridMarginH: 80
    property real gridAreaTop: 120  // space reserved for top bar
    property real gridMarginBottom: 48
    property real availWidth: width - gridMarginH * 2
    property real availHeight: height - gridAreaTop - gridMarginBottom
    property real cardGap: 20

    property int columns: {
        let n = displayedWindows.length;
        if (n <= 0) return 1;
        if (n <= 2) return n;
        if (n <= 4) return 2;
        if (n <= 6) return 3;
        return 4;
    }
    property int rows: Math.max(1, Math.ceil(displayedWindows.length / columns))

    property real maxCardW: (availWidth - (columns - 1) * cardGap) / columns
    property real maxCardH: (availHeight - (rows - 1) * cardGap) / rows
    property real titleH: 32

    // Fit card to both width and height constraints, cap at 440px wide
    property real fitFromW: Math.min(maxCardW, 440)
    property real fitFromH: maxCardH > titleH
        ? Math.min((maxCardH - titleH) / 0.5625, 440) : 200
    property real cardW: Math.max(200, Math.min(fitFromW, fitFromH))
    property real previewH: cardW * 0.5625  // 16:9
    property real cardH: previewH + titleH

    property real totalGridW: columns * cardW + (columns - 1) * cardGap
    property real totalGridH: rows * cardH + (rows - 1) * cardGap

    function toggle() {
        visible = !visible;
    }

    onVisibleChanged: {
        if (visible) {
            searchInput.text = "";
            selectedIndex = 0;
            searchInput.forceActiveFocus();
        }
    }

    function activateWindow(toplevel) {
        if (!toplevel) return;
        let wsId = toplevel.workspace?.id;
        if (wsId) Hyprland.dispatch("workspace " + wsId);
        toplevel.wayland?.activate();
        overview.visible = false;
    }

    function activateSelected() {
        if (selectedIndex >= 0 && selectedIndex < displayedWindows.length) {
            activateWindow(displayedWindows[selectedIndex]);
        }
    }

    // Clamp selectedIndex when list changes
    onDisplayedWindowsChanged: {
        if (displayedWindows.length === 0) {
            selectedIndex = -1;
        } else if (selectedIndex >= displayedWindows.length) {
            selectedIndex = 0;
        } else if (selectedIndex < 0) {
            selectedIndex = 0;
        }
    }

    GlobalShortcut {
        appid: "solid-shell"
        name: "overview"
        description: "Toggle window overview"
        onPressed: overview.toggle()
    }

    Shortcut {
        sequence: "Escape"
        onActivated: overview.visible = false
    }

    // Backdrop
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(
            Root.Theme.base00.r,
            Root.Theme.base00.g,
            Root.Theme.base00.b,
            Root.Theme.overviewGlassOpacity
        )

        MouseArea {
            anchors.fill: parent
            onClicked: overview.visible = false
        }
    }

    // Top section: search bar + workspace dots
    Column {
        id: topSection
        anchors.top: parent.top
        anchors.topMargin: 28
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 12

        // Search bar
        Rectangle {
            id: searchBar
            anchors.horizontalCenter: parent.horizontalCenter
            width: Math.min(360, overview.width * 0.25)
            height: 36
            radius: 18
            color: Root.Theme.base01

            border.width: 1
            border.color: searchInput.text !== "" ? Root.Theme.base0D : Root.Theme.base02

            Row {
                anchors.fill: parent
                anchors.leftMargin: 14
                anchors.rightMargin: 14
                spacing: 8

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "/"
                    font.pixelSize: 13
                    color: Root.Theme.base03
                }

                Item {
                    width: parent.width - 24
                    height: parent.height

                    TextInput {
                        id: searchInput
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width
                        font.pixelSize: Root.Theme.fontSizePrimary
                            color: Root.Theme.base05
                        selectionColor: Root.Theme.base0D
                        selectedTextColor: Root.Theme.base00
                        clip: true

                        Keys.onReturnPressed: activateSelected()
                        Keys.onEnterPressed: activateSelected()

                        Keys.onLeftPressed: (event) => {
                            if (overview.selectedIndex > 0)
                                overview.selectedIndex--;
                            event.accepted = true;
                        }
                        Keys.onRightPressed: (event) => {
                            if (overview.selectedIndex < overview.displayedWindows.length - 1)
                                overview.selectedIndex++;
                            event.accepted = true;
                        }
                        Keys.onUpPressed: (event) => {
                            let idx = overview.selectedIndex;
                            let cols = overview.columns;
                            if (idx - cols >= 0)
                                overview.selectedIndex = idx - cols;
                            event.accepted = true;
                        }
                        Keys.onDownPressed: (event) => {
                            let idx = overview.selectedIndex;
                            let cols = overview.columns;
                            let count = overview.displayedWindows.length;
                            if (idx + cols < count)
                                overview.selectedIndex = idx + cols;
                            event.accepted = true;
                        }
                        Keys.onTabPressed: (event) => {
                            let count = overview.displayedWindows.length;
                            if (count > 0)
                                overview.selectedIndex = (overview.selectedIndex + 1) % count;
                            event.accepted = true;
                        }
                        Keys.onBacktabPressed: (event) => {
                            let count = overview.displayedWindows.length;
                            if (count > 0)
                                overview.selectedIndex = (overview.selectedIndex - 1 + count) % count;
                            event.accepted = true;
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        visible: searchInput.text === ""
                        text: "Search\u2026"
                        font.pixelSize: Root.Theme.fontSizePrimary
                            color: Root.Theme.base03
                    }
                }
            }
        }

        // Workspace dots — centered below search
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Repeater {
                model: Hyprland.workspaces

                delegate: Rectangle {
                    required property var modelData
                    width: modelData.focused ? 18 : 8
                    height: 8
                    radius: 4
                    color: modelData.focused ? Root.Theme.base0D : Root.Theme.base03

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            Hyprland.dispatch("workspace " + modelData.id);
                            overview.visible = false;
                        }
                    }
                }
            }
        }
    }

    // Window grid — centered in remaining space
    Item {
        id: gridContainer
        anchors.top: topSection.bottom
        anchors.topMargin: 16
        anchors.bottom: parent.bottom
        anchors.bottomMargin: overview.gridMarginBottom
        anchors.left: parent.left
        anchors.right: parent.right

        Item {
            anchors.centerIn: parent
            width: overview.totalGridW
            height: overview.totalGridH

            Repeater {
                model: overview.displayedWindows

                delegate: WindowCard {
                    required property var modelData
                    required property int index

                    x: (index % overview.columns) * (overview.cardW + overview.cardGap)
                    y: Math.floor(index / overview.columns) * (overview.cardH + overview.cardGap)

                    window: modelData
                    selected: index === overview.selectedIndex
                    cardWidth: overview.cardW
                    cardHeight: overview.previewH
                    overviewVisible: overview.visible
                    onActivated: overview.activateWindow(modelData)
                }
            }
        }

        // Empty state
        Text {
            anchors.centerIn: parent
            visible: overview.displayedWindows.length === 0
            text: overview.searching ? "No matches" : "No windows"
            font.pixelSize: Root.Theme.fontSizePrimary
            color: Root.Theme.base03
        }
    }
}
