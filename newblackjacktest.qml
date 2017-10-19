import QtQuick 2.0

Rectangle {
	id: window

	//Size of the window
	width: 1200
	height: 700

	//Background image
	Image {
		source: "cardTable.jpeg"
		fillMode: Image.PreserveAspectFit
		anchors.fill: parent
	}

	//Dealer (could potentially increase the height and put an array of cards on the display here)
	//This kind of block will eventually be reformed into a component, to make it easier to create multiple players
	Rectangle {
		id: dealer
		width: 100
		height: 50
		color: "yellow"
		y: 100
		anchors.horizontalCenter: window.horizontalCenter

		Text {
			id: dealerName
			text: "Dealer"
			y: 10
			anchors.horizontalCenter: dealer.horizontalCenter
			font.pointSize: 14
			font.bold: true
			color: "black"
		}
	}

	//Player (could potentially increase the height upwards to make space for an array of cards to display)
	Rectangle {
		id: player
		width: 100
		height: 50
		color: "yellow"
		y : 550
		anchors.horizontalCenter: window.horizontalCenter

		Text {
			id: playerName
			text: "Player"
			y: 20
			anchors.horizontalCenter: player.horizontalCenter
			font.pointSize: 14
			font.bold: true
			color: "black"
		}
	}
	
	//Button for HIT
	Rectangle {
	    	id: hit
            	color: "green"; width: 50; height: 50;
            	radius: 3;
		anchors.left: stay.right
		y: 600
            	Text {
			font.pointSize: 14
                	text: "Hit"; color: "white"; horizontalAlignment: Text.AlignHCenter;
			x: 15
			y: 17
                	verticalAlignment: Text.AlignVCenter;
            	}
            	MouseArea {
                	anchors.fill: parent;
                	onClicked: playerMove(0);
            	}
        }

	//Button for STAY
	Rectangle {
		id: stay
            	color: "red"; width: 50; height: 50;
            	radius: 3;
		anchors.left: player.left
		y: 600

            	Text {
               		font.pointSize: 14
               		text: "Stay"; color: "white"; horizontalAlignment: Text.AlignHCenter
			x: 11
			y: 17
                	verticalAlignment: Text.AlignVCenter;
            	}
            	MouseArea {
                	anchors.fill: parent;
                	onClicked: playerMove(1);
            	}
        }

}
