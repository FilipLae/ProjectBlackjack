import QtQuick 2.0

//Shows the card

Item {
	id: card
	width: 55; height: 75
	property alias buttonImage: cardImage


	Rectangle {
		id: rectangle
		anchors.fill: parent

		Image {
			id: cardImage
			source: "cardBack.jpg"
                	fillMode: Image.Stretch
                	anchors.fill: parent
          	}

		
	}
}
