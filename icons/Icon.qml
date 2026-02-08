import QtQuick
import QtQuick.Effects

Item {
    id: root

    property string name

    property color color: "white"

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
