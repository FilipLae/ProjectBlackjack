import QtQuick 2.0
Row {
    Column {
        height: 300;
        Text {
            width: 100; wrapMode: Text.WrapAnywhere; font.pixelSize: 30;
            text: "Dealer"; color: "black";
        }
    }

    Column {
        height: 300;
        Rectangle {
            color: "white"; width: childrenRect.width; height: 100;
            Text {
                width: 100; height: 30; font.pixelSize: 30;
                text: "Filler"; color: "white"; horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
            }
        }
        Rectangle {
            color: "green"; width: childrenRect.width; height: childrenRect.height;
            radius: 3;
            Text {
                width: 100; height: 30; font.pixelSize: 30;
                text: "Hit"; color: "white"; horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: playerMove(0);
            }
        }

        Rectangle {
            color: "red"; width: childrenRect.width; height: childrenRect.height;
            radius: 3;
            Text {
                width: 100; height: 30; font.pixelSize: 30;
                text: "Stay"; color: "white"; horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
            }
            MouseArea {
                anchors.fill: parent;
                onClicked: playerMove(1);
            }
        }
    }

    Column {
        height: 300;
        Text {
            width: 100; wrapMode: Text.WrapAnywhere; font.pixelSize: 30;
            text: "Player"; color: "black";
        }
    }
}