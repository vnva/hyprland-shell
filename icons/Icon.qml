import QtQuick
import QtQuick.Effects

Item {
    id: root

    property string name
    property real size: 12

    property color color: "white"

    width: size + 1
    height: size + 1

    Image {
        id: image
        anchors.fill: parent
        source: root.name ? "source/" + root.name + ".svg" : ""
        sourceSize: Qt.size(width, height)
        visible: false
    }

    MultiEffect {
        anchors.fill: image
        source: image
        brightness: 1.0
        colorization: 1.0
        colorizationColor: root.color
    }
}
