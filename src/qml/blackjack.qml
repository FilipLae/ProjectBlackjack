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
		height: 300; 
		width: 600;
		anchors.centerIn: parent
		color: "grey"
		visible: false
		radius: 10
		z: 100;
		Text {
			id: output
			text: "GAME FINISHED \n\n\nClick 'Deal' to start a new one!"
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
		color: "transparent"
		y: 105
		anchors.horizontalCenter: window.horizontalCenter

		Text {
			id: dealerName
			text: "Dealer"
			y: 0
			anchors.horizontalCenter: dealerPerson.horizontalCenter
			font.pointSize: 16
			font.bold: true
			color: "black"
		}
		MouseArea {
			id: dealerMove
			onClicked: {
				var ds = scoreDealerExternal();
				if (parseInt(ds) < 17) {
					dealer.appendList();
					dealerMove.clicked(Qt.LeftButton)
				} else {
					dealer.flipFirst();
					output.text = "Game Finished \n\n"+finalScore()+"\n\nPress deal to start a new one!"
					finishedScreen.visible = true
				}
				/*var x = (Math.floor(Math.random()*1000) % 2);
				if ( x == 0 ){
					dealer.appendList();
					dealerMove.clicked(Qt.LeftButton)
				}else{
					
				}
				*/
			}
		}

		Grid {
			id: dealerHand
			rows: 1; columns: 10; spacing: -30
			anchors.bottom: parent.bottom
			transform: Scale { xScale: 1.4; yScale: 1.4 } 
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
		color: "transparent"
		y : 390
		anchors.horizontalCenter: window.horizontalCenter

		Text {
			id: playerName
			text: "Player"
			y: 135
			anchors.horizontalCenter: playerPerson.horizontalCenter
			font.pointSize: 16
			font.bold: true
			color: "black"
		}

		Grid {
			id: playerHand
			rows: 1; columns: 10; spacing: -30
			transform: Scale { xScale: 1.4; yScale: 1.4 } 
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
		color: "green"; 
		width: 50; 
		height: 50;
		radius: 3;
		x: playerPerson.x + 55
		y: 565
		Text {
			font.pointSize: 14
			text: "Hit"; 
			color: "white"; 
			horizontalAlignment: Text.AlignHCenter;
			x: 10
			y: 11
			verticalAlignment: Text.AlignVCenter;
		}
		MouseArea {
			anchors.fill: parent;
			onClicked: {
				player.appendList2();
			}
		}
    }

	//Button for STAY
	Rectangle {
		id: stay
		visible: false
        color: "red"; 
		width: 50; 
		height: 50;
        radius: 3;
		x: playerPerson.x
		y: 565
		Text {
			font.pointSize: 14
			text: "Stay"; 
			color: "white"; 
			horizontalAlignment: Text.AlignHCenter
			x: 5
			y: 11
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
	Text {
		text: "Press 'Deal' to start!"
		id: pressToDeal
		color: "black"
		font.pointSize: 18
		visible: true
		x: (window.width / 2) - 100
		y: (window.height / 2) - 50
	}
	
	//Button for Dealing
	Rectangle {
		id: deal
		color: "#333300"; 
		width: 150; 
		height: 100;
		x: 25
		y: window.height - 125
		radius: 5
		
		Text {
			font.pointSize: 20
			text: "Deal"; color: "white"
			anchors.centerIn: parent
		}
		MouseArea {
			anchors.fill: parent;
			onClicked: {
				finishedScreen.visible = false;
				player.clear();
				dealer.clear();
				player.appendList2();
				dealer.appendFirst();
				player.appendList2();
				dealer.appendList();
				hit.visible = true;
				stay.visible = true;
				pressToDeal.visible = false;
			}
		}
	}

}
