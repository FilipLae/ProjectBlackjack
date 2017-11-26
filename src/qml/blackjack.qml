import QtQuick 2.0
import QtQuick.Controls 1.2

Rectangle {
	id: window

	//Size of the window
	width: 1200
	height: 700
	visible: true

	//Background image
	Image {
		source: "../Images/cardTable.jpeg"
		fillMode: Image.PreserveAspectFit
		anchors.fill: parent
	}

	//Endgame screen
	Rectangle {
		id: finishedScreen
		height: 300; width: 800;
		anchors.centerIn: parent
		color: "blue"
		visible: false

		Text {
			id: output
			text: "GAME FINISHED \n\n\nClick deal to start a new one!"
			anchors.centerIn: parent
			font.pointSize: 20
			font.bold: true
			color: "white"
		}
		
	}

	//Dealer
	Rectangle {
		id: dealerPerson
		width: 100
		height: 125
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
		MouseArea {
			id: dealerMove
			onClicked: {
				var x = (Math.floor(Math.random()*1000) % 2);
				if ( x == 0 ){
					var z = (Math.floor (Math.random() * 12938));
					dealer.appendList(z);
					dealerMove.clicked(Qt.LeftButton)
				}else{
					dealer.flipFirst();
					output.text = "Game Finished \n\n"+finalScore()+"\n\nPress deal to start a new one!"
					finishedScreen.visible = true
				}
			}
		}

		Grid {
			id: dealerHand
			rows: 1; columns: 10; spacing: -30
			anchors.bottom: parent.bottom

			Repeater {
				model: dealer.list
				delegate: Cardback { buttonImage.source: modelData.text ; cardFront: modelData.text3 }	
			}
		}
	}

	//Player
	Rectangle {
		id: playerPerson
		width: 100
		height: 175
		color: "yellow"
		y : 475
		anchors.horizontalCenter: window.horizontalCenter

		Text {
			id: playerName
			text: "Player"
			y: 95
			anchors.horizontalCenter: player.horizontalCenter
			font.pointSize: 14
			font.bold: true
			color: "black"
		}

		Grid {
			id: playerHand
			rows: 1; columns: 10; spacing: -30

			Repeater {
				model: player.list2
				delegate: Cardback {  buttonImage.source: modelData.text; cardFront: modelData.text3 }
			}

		}
	}
	
	//Button for HIT
	Rectangle {
	    	id: hit
		visible: false
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
                	onClicked: {
				var z = (Math.floor (Math.random() * 12938));
				player.appendList2(z);

			}
            	}
        }

	//Button for STAY
	Rectangle {
		id: stay
		visible: false
            	color: "red"; width: 50; height: 50;
            	radius: 3;
		anchors.left: playerPerson.left
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
                	onClicked: { 	
					hit.visible = false;
					stay.visible = false 
					dealerMove.clicked(Qt.LeftButton)
				   }
            	}
        }

	//Button for Dealing
	Rectangle {
		id: deal
		color: "darkblue"; width: 100; height: 50;
		anchors.left: window.left
		anchors.bottom: window.bottom
		
		Text {
			font.pointSize: 14
			text: "Deal"; color: "white"
			anchors.centerIn: parent
		}
		MouseArea {
			anchors.fill: parent;
			onClicked: {
				finishedScreen.visible = false;
				player.clear();
				dealer.clear();
				var x = (Math.floor (Math.random() * 12938));
				var y = (Math.floor (Math.random() * 12938));
				var z = (Math.floor (Math.random() * 12938));
				var w = (Math.floor (Math.random() * 12938));
				player.appendList2(x);
				dealer.appendFirst(z);
				player.appendList2(y);
				dealer.appendList(w);
				hit.visible = true;
				stay.visible = true
			}
		}
	}

}
