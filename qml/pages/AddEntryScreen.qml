import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: addEntryScreen

    anchors.fill: parent

    signal generatePasswordRequested()
    signal backRequested()
    signal saveEntryRequested(
        string title,
        string username,
        string password,
        string website,
        string notes
    )

function setGeneratedPassword(password) {
    passwordField.text = password
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

            spacing: units.gu(1.4)

            Label {
                text: "‹  Back"
                color: Theme.accent
                font.pixelSize: units.gu(2)

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -units.gu(1)

                    onClicked: {
                        addEntryScreen.backRequested()
                    }
                }
            }

            Label {
                text: "Add Password"
                color: Theme.textPrimary
                font.pixelSize: units.gu(3)
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: "Save a new login securely inside your vault."
                color: Theme.textSecondary
                font.pixelSize: units.gu(1.7)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            TVDivider {
                Layout.fillWidth: true
            }

            Label {
                text: "Service"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: titleField
                Layout.fillWidth: true
                placeholderText: "GitHub"
            }

            Label {
                text: "Username or Email"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: usernameField
                Layout.fillWidth: true
                placeholderText: "john@example.com"
            }

            Label {
    text: "Password"
    color: Theme.textPrimary
    font.pixelSize: units.gu(1.7)
}

RowLayout {
    Layout.fillWidth: true
    spacing: units.gu(1)

    TVTextField {
        id: passwordField
        Layout.fillWidth: true

        placeholderText: "Enter or generate password"
        echoMode: TextInput.Password
    }

    Label {
        text: "Generate"
        color: Theme.accent
        font.pixelSize: units.gu(1.6)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -units.gu(1)

            onClicked: {
                addEntryScreen.generatePasswordRequested()
            }
        }
    }
}

            Label {
                text: "Website"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: websiteField
                Layout.fillWidth: true
                placeholderText: "https://github.com"
            }

            Label {
                text: "Notes"
                color: Theme.textPrimary
                font.pixelSize: units.gu(1.7)
            }

            TVTextField {
                id: notesField
                Layout.fillWidth: true
                placeholderText: "Optional notes"
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

            Item {
                Layout.fillHeight: true
            }

            TVButton {
                Layout.fillWidth: true
                text: "Save Password"

                onClicked: {
                    errorLabel.text = ""

                    var title = titleField.text.trim()
                    var username = usernameField.text.trim()
                    var password = passwordField.text
                    var website = websiteField.text.trim()
                    var notes = notesField.text.trim()

                    if (title.length === 0) {
                        errorLabel.text = "Please enter a service name."
                        return
                    }

                    if (password.length === 0) {
                        errorLabel.text = "Please enter a password."
                        return
                    }

                    addEntryScreen.saveEntryRequested(
                        title,
                        username,
                        password,
                        website,
                        notes
                    )
                }
            }
        }
    }
}