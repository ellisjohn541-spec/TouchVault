import QtQuick 2.7
import QtQuick.Controls 2.7

import "../style"

TextField {

    id: root

    color: Theme.textPrimary

    font.pixelSize: Theme.bodySize + 8

    placeholderTextColor: Theme.textSecondary

    selectByMouse: true

    padding: Theme.spacing

    background: Rectangle {

        color: Theme.card

        radius: Theme.radius

        border.width: root.activeFocus ? 2 : 1

        border.color: root.activeFocus ? Theme.accent : Theme.divider

        Behavior on border.color {
            ColorAnimation {
                duration: Theme.animationSpeed
            }
        }

        Behavior on border.width {
            NumberAnimation {
                duration: Theme.animationSpeed
            }
        }
    }
}