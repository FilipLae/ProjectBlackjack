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
 
	Grid{
		id: bLAHdealerHand
                rows: 1; columns: 50; spacing: -30
                anchors.bottom: parent.bottom
 
                Repeater {
                	model: dealer.list
                        delegate: Cardback { buttonImage.source: modelData.text;cardFront: modelData.text3 }
                        }
	}

	Button {
		anchors.centerIn: parent
		text: qsTr("Start Game")

		onClicked: {
               		dealer.appendFirst(Math.ceil(Math.random() * 2)==0? Math.floor(Math.random() * 13975): Math.floor(Math.random() * -13975));
		}
	}

        Button {
		anchors.left: parent.left
                text: qsTr("End Game")

                onClicked: {
                        dealer.flipFirst();
		}
	}

	Button {
		anchors.right: parent.right
		text: qsTr("Mid Game")

		onClicked: {
			dealer.appendList(Math.floor(Math.random() * 13975));
			player.appendList2(Math.floor(Math.random() * 13975));
		}
	}


        Button {
		id: testing
		anchors.bottom: bLAHdealerHand.top
		text: qsTr("COUNT CARDS")

		onClicked: {
			testing.text = finalScore();
		}
	}
}
