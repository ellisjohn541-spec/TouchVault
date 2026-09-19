import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: createVaultScreen

    anchors.fill: parent

    signal backRequested()
    signal createRequested(string vaultName, string masterPassword)
    signal vaultCreated()

    function showCreateResult(success, message) {
        resultLabel.color = success ? Theme.success : Theme.error
        resultLabel.text = message
        resultLabel.visible = true
        createButton.enabled = !success

        if (success) {
            successTimer.start()
        }
    }

    Timer {
        id: successTimer
        interval: 1200
        repeat: false

        onTriggered: {
            createVaultScreen.vaultCreated()
        }
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

            spacing: units.gu(1.5)

            Label {
                text: "‹  Back"
                color: Theme.accent
                font.pixelSize: units.gu(2)

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -units.gu(1)

                    onClicked: {
                        createVaultScreen.backRequested()
                    }
                }
            }

            Item {
                Layout.preferredHeight: units.gu(1)
            }

            Label {
                text: "Create New Vault"
                color: Theme.textPrimary
                font.pixelSize: units.gu(3)
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: "Your vault will be encrypted locally using your master password. Only you can unlock it."
                color: Theme.textSecondary
                font.pixelSize: units.gu(1.7)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item {
                Layout.preferredHeight: units.gu(1)
            }

            TVDivider {
                Layout.fillWidth: true
            }

            Label {
                text: "Vault Name"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: vaultNameField
                Layout.fillWidth: true
                placeholderText: "Personal Vault"
            }

            Label {
                text: "Master Password"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: masterPasswordField
                Layout.fillWidth: true
                placeholderText: "Enter master password"
                echoMode: TextInput.Password
            }

            Label {
                text: "Confirm Password"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: confirmPasswordField
                Layout.fillWidth: true
                placeholderText: "Confirm master password"
                echoMode: TextInput.Password
            }

            Label {
                id: errorLabel

                text: ""
                visible: text.length > 0

                color: Theme.error
                font.pixelSize: units.gu(1.5)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Label {
                id: resultLabel

                text: ""
                visible: false

                color: Theme.success
                font.pixelSize: units.gu(1.7)
                font.bold: true

                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }

            TVButton {
                id: createButton

                Layout.fillWidth: true
                text: "Create Vault"

                onClicked: {
                    errorLabel.text = ""
                    resultLabel.text = ""
                    resultLabel.visible = false

                    var vaultName = vaultNameField.text.trim()
                    var password = masterPasswordField.text
                    var confirmation = confirmPasswordField.text

                    if (vaultName.length === 0) {
                        errorLabel.text = "Please enter a vault name."
                        return
                    }

                    if (password.length < 12) {
                        errorLabel.text =
                            "Use a master password with at least 12 characters."
                        return
                    }

                    if (password !== confirmation) {
                        errorLabel.text = "The passwords do not match."
                        return
                    }

                    createVaultScreen.createRequested(
                        vaultName,
                        password
                    )
                }
            }
        }
    }
}