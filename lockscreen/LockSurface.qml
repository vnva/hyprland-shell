import QtQuick
import Quickshell
import ".." as Root

Item {
	id: root
	required property LockContext context

	Rectangle {
		anchors.fill: parent
		color: "#000000"
	}

	Item {
		anchors.centerIn: parent
		width: 320
		height: column.height

		Column {
			id: column
			width: parent.width
			spacing: 24

			Text {
				id: clock
				property var date: new Date()

				anchors.horizontalCenter: parent.horizontalCenter
				text: {
					const hours = this.date.getHours().toString().padStart(2, '0');
					const minutes = this.date.getMinutes().toString().padStart(2, '0');
					return `${hours}:${minutes}`;
				}
				font.family: Root.Theme.fontFamily
				font.pixelSize: 64
				color: Root.Theme.base05

				Timer {
					running: true
					repeat: true
					interval: 1000
					onTriggered: clock.date = new Date();
				}
			}

			Text {
				anchors.horizontalCenter: parent.horizontalCenter
				text: Qt.formatDate(new Date(), "dddd, MMMM d")
				font.family: Root.Theme.fontFamily
				font.pixelSize: Root.Theme.fontSizePrimary
				color: Root.Theme.base03
			}

			Item { width: 1; height: 16 }

			Rectangle {
				width: parent.width
				height: 40
				radius: 4
				color: Root.Theme.base01
				border.width: 1
				border.color: passwordBox.activeFocus ? Root.Theme.base0D : Root.Theme.base02

				Behavior on border.color {
					ColorAnimation {
						duration: Root.Theme.transitionDuration
						easing.type: Easing.OutQuad
					}
				}

				TextInput {
					id: passwordBox
					anchors.fill: parent
					opacity: 0
					focus: true
					enabled: !root.context.unlockInProgress

					onTextChanged: root.context.currentText = this.text;
					onAccepted: root.context.tryUnlock();

					Connections {
						target: root.context
						function onCurrentTextChanged() {
							passwordBox.text = root.context.currentText;
						}
					}
				}

				Row {
					anchors.verticalCenter: parent.verticalCenter
					anchors.left: parent.left
					anchors.leftMargin: 12
					spacing: 6
					visible: root.context.currentText !== ""

					Repeater {
						model: root.context.currentText.length

						Rectangle {
							width: 8
							height: 8
							radius: 4
							color: Root.Theme.base05
						}
					}
				}

				Text {
					anchors.fill: parent
					anchors.leftMargin: 12
					verticalAlignment: Text.AlignVCenter
					visible: root.context.currentText === ""
					text: root.context.unlockInProgress ? "Authenticating..." : "Password"
					font.family: Root.Theme.fontFamily
					font.pixelSize: Root.Theme.fontSizePrimary
					color: Root.Theme.base03
				}
			}

			Text {
				width: parent.width
				anchors.horizontalCenter: parent.horizontalCenter
				visible: root.context.showFailure
				text: "Incorrect password"
				font.family: Root.Theme.fontFamily
				font.pixelSize: Root.Theme.fontSizeSecondary
				color: Root.Theme.base09
				wrapMode: Text.WordWrap
				horizontalAlignment: Text.AlignHCenter
			}
		}
	}
}
