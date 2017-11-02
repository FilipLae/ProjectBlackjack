import QtQuick 2.0
import QtQuick.Controls 1.2

//Basic main screen

ApplicationWindow {
	id: root
	width: 1200; height: 700
	visible: true

	Image {
		source: "mainBackground.jpeg"
		fillMode: Image.PreserveAspectFit
		anchors.fill: parent
	}
		

	Text {
		id: mainText
		text: "Project Blackjack"
		y: 50
		color: "yellow"
		anchors.horizontalCenter: parent.horizontalCenter
		font.pointSize: 50
		font.bold: true
	}

	Button {
		anchors.centerIn: parent
		text: qsTr("Start Game")

		onClicked: {
			var component = Qt.createComponent("Newblackjacktest.qml")
			var window    = component.createObject(root)
		}
	}
}
