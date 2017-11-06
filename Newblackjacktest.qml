import QtQuick 2.0
import QtQuick.Controls 1.2

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

	Rectangle {
		id: finishedScreen
		height: 300; width: 800;
		anchors.centerIn: parent
		color: "blue"
		visible: false

		Text {
			text: "GAME FINISHED \n\n\nClick deal to start a new one!"
			anchors.centerIn: parent
			font.pointSize: 20
			font.bold: true
			color: "white"
		}
		
	}

	//Dealer (could potentially increase the height and put an array of cards on the display here)
	//This kind of block will eventually be reformed into a component, to make it easier to create multiple players
	Rectangle {
		id: dealer
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
					if (dealerModel.count <= 9) {
					var x = Math.floor(Math.random()*1000) % 4;
                               		var y = (Math.floor(Math.random()*1000) % 13) + 1;

                                	if (x == 0){
                                        	dealerModel.append({ _id: "./Images/H" + y + ".png" })
                                	} else if (x == 1){
                                        	dealerModel.append({ _id: "./Images/S" + y + ".png" })
                                	} else if (x == 2){
                                        	dealerModel.append({ _id: "./Images/C" + y + ".png" })
                                	} else {
                                        	dealerModel.append({ _id: "./Images/D" + y + ".png" })
                                	}

				
					dealerMove.clicked(Qt.LeftButton)
				}
				}else{
					finishedScreen.visible = true
				}
			}
		}

		ListModel {
			id: dealerModel
		}

		Grid {
			id: dealerHand
			rows: 1; columns: 10; spacing: -30
			anchors.bottom: parent.bottom

			Repeater {
				model: dealerModel
				delegate: Cardback { buttonImage.source: _id }		
			}
		}
	}

	//Player (could potentially increase the height upwards to make space for an array of cards to display)
	Rectangle {
		id: player
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

		ListModel {
			id: playerModel

		}

		Grid {
			id: playerHand
			rows: 1; columns: 10; spacing: -30

			Repeater {
				model: playerModel
				delegate: Cardback {  buttonImage.source: _id }
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
				var x = Math.floor(Math.random()*1000) % 4;
                                var y = (Math.floor(Math.random()*1000) % 13) + 1;

				if (x == 0){
                                        playerModel.append({ _id: "./Images/H" + y + ".png" })
                                } else if (x == 1){
                                        playerModel.append({ _id: "./Images/S" + y + ".png" })
                                } else if (x == 2){
                                        playerModel.append({ _id: "./Images/C" + y + ".png" })
                                } else {
                                        playerModel.append({ _id: "./Images/D" + y + ".png" })
                                }
			}//playerMove(0);
            	}
        }

	//Button for STAY
	Rectangle {
		id: stay
		visible: false
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
                	onClicked: { 	hit.visible = false;
					stay.visible = false 
					dealerMove.clicked(Qt.LeftButton)
				   }//playerMove(1);
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
				playerModel.clear();
				dealerModel.clear();
				playerModel.append({ _id: "cardBack.jpg"});
				dealerModel.append({ _id: "cardBack.jpg"});
				var x = Math.floor(Math.random()*1000) % 4;
				var y = (Math.floor(Math.random()*1000) % 13) + 1;
				var a = Math.floor(Math.random()*1000) % 4;
				var b = (Math.floor(Math.random()*1000) % 13) + 1;
				if (x == 0){
					playerModel.append({ _id: "./Images/H" + y + ".png" })
				} else if (x == 1){
					playerModel.append({ _id: "./Images/S" + y + ".png" })
				} else if (x == 2){
					playerModel.append({ _id: "./Images/C" + y + ".png" })
				} else {
					playerModel.append({ _id: "./Images/D" + y + ".png" })
				}
				if (a == 0){
                                	dealerModel.append({ _id: "./Images/H" + b + ".png" })
                                } else if (a == 1){
                                	dealerModel.append({ _id: "./Images/S" + b + ".png" })
                                } else if (a == 2){
                                	dealerModel.append({ _id: "./Images/C" + b + ".png" })
                                } else {
                                	dealerModel.append({ _id: "./Images/D" + b + ".png" })
                                }
				hit.visible = true;
				stay.visible = true
			}
		}
	}

}
