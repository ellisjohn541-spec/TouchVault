import QtQuick 2.7
import QtQuick.Controls 2.7
import "../style"

Rectangle {

    id: root

    property alias text: buttonText.text
    signal clicked()

    width: parent ? parent.width : 300
    height: units.gu(6)

    radius: Theme.radius
    color: mouseArea.pressed ? Qt.darker(Theme.accent, 1.2) : Theme.accent

    scale: mouseArea.pressed ? 0.97 : 1.0

    Behavior on color {
        ColorAnimation {
            duration: Theme.animationSpeed
        }
    }

     Behavior on scale {
        NumberAnimation {
            duration: 80
        }
    }


    Text {
        id: buttonText

        anchors.centerIn: parent

        color: Theme.textPrimary
        font.pixelSize: units.gu(2)
        font.bold: true
    }

    MouseArea {

        id: mouseArea

        anchors.fill: parent

        onClicked: root.clicked()
    }
}