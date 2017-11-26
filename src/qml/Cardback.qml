import QtQuick 2.0

//Shows the card

Item {
	id: card
	width: 55; height: 75
	property string front : {}
	property alias buttonImage: cardImage
	property alias cardFront : card.front


	Rectangle {
		id: rectangle
		anchors.fill: parent

		Image {
			id: cardImage
			source: "../Images/cardBack.jpg"
                	fillMode: Image.Stretch
                	anchors.fill: parent
          	}

		
	}
}
