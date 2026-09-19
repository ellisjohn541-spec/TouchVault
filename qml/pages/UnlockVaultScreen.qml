import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: unlockVaultScreen

    anchors.fill: parent

    signal backRequested()
    signal unlockRequested(string masterPassword)

    property string vaultName: ""

    function showUnlockResult(success, message) {
        errorLabel.text = message
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.background

        ColumnLayout {
            anchors {
                fill: parent
                leftMargin: units.gu(2)
                rightMargin: units.gu(2)
                topMargin: units.gu(3)
                bottomMargin: units.gu(2)
            }

            spacing: units.gu(2)

            Label {
                text: "‹ Back"
                color: Theme.accent

                MouseArea {
                    anchors.fill: parent
                     onClicked: {
                        unlockVaultScreen.backRequested()
                    }
                }
            }

            Label {
                text: "Unlock " + vaultName
                color: Theme.textPrimary
                font.pixelSize: units.gu(3)
                font.bold: true
            }

            Label {
                text: "Enter your master password."
                color: Theme.textSecondary
            }

            TVDivider {
                Layout.fillWidth: true
            }

            TVTextField {
                id: passwordField

                Layout.fillWidth: true

                placeholderText: "Master Password"

                echoMode: TextInput.Password
            }

            Label {
                id: errorLabel

                visible: text.length > 0

                color: Theme.error

                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }

            TVButton {
                Layout.fillWidth: true

                text: "Unlock Vault"

                onClicked: {
                    errorLabel.text = ""

                    unlockVaultScreen.unlockRequested(
                        passwordField.text
                    )
                }
            }
        }
    }
}