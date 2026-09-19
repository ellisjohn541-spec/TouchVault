import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: welcomeScreen

    anchors.fill: parent

    signal createVaultRequested()
    signal openVaultRequested()

    Rectangle {

        anchors.fill: parent
        color: Theme.background

        ColumnLayout {

        anchors {
        fill: parent
        leftMargin: units.gu(2)
        rightMargin: units.gu(2)
        topMargin: units.gu(4)
        bottomMargin: units.gu(2)
        }

        spacing: units.gu(2)

            TVLogo {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: units.gu(22)
                Layout.preferredHeight: units.gu(22)
            }


            Label {

                text: "Your passwords.\nYour device.\nYour control."

                color: Theme.textSecondary

                lineHeight: 1.2

                Layout.fillWidth: true

                wrapMode: Text.WordWrap

                horizontalAlignment: Text.AlignHCenter

                Layout.alignment: Qt.AlignHCenter
            }

            Item {
                Layout.preferredHeight: units.gu(2)
            }

            //TVDivider {
                //Layout.fillWidth: true
            //}

            TVButton {

                Layout.fillWidth: true

                text: "Create New Vault"

                onClicked: welcomeScreen.createVaultRequested()
            }

            Item {
               Layout.preferredHeight: units.gu(2)
            }

            Item {
                Layout.preferredHeight: units.gu(2)
            }       

            TVButton {

                Layout.fillWidth: true

                text: "Open Existing Vault"

                onClicked: welcomeScreen.openVaultRequested()
            }

            Label {

                text: "KeePass Compatible"

                color: Theme.textSecondary

                font.pixelSize: units.gu(2)

                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
}