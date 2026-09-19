import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: editEntryScreen

    anchors.fill: parent

    signal generatePasswordRequested()
    signal backRequested()
    signal saveChangesRequested(
        string title,
        string username,
        string password,
        string website,
        string notes
    )

    property string title: ""
    property string username: ""
    property string password: ""
    property string website: ""
    property string notes: ""

    function setEntry(entry) {
        title = entry.title || ""
        username = entry.username || ""
        password = entry.password || ""
        website = entry.website || ""
        notes = entry.notes || ""

        titleField.text = title
        usernameField.text = username
        passwordField.text = password
        websiteField.text = website
        notesField.text = notes
    }

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
                text: "‹ Back"
                color: Theme.accent

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -units.gu(1)

                    onClicked: {
                        editEntryScreen.backRequested()
                    }
                }
            }

            Label {
                text: "Edit Password"
                color: Theme.textPrimary
                font.pixelSize: units.gu(3)
                font.bold: true
                Layout.fillWidth: true
            }

            TVDivider {
                Layout.fillWidth: true
            }

            Label {
                text: "Service"
                color: Theme.textPrimary
            }

            TVTextField {
                id: titleField
                Layout.fillWidth: true
            }

            Label {
                text: "Username or Email"
                color: Theme.textPrimary
            }

            TVTextField {
                id: usernameField
                Layout.fillWidth: true
            }

            Label {
    text: "Password"
    color: Theme.textPrimary
}

RowLayout {
    Layout.fillWidth: true
    spacing: units.gu(1)

    TVTextField {
        id: passwordField

        Layout.fillWidth: true

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
                editEntryScreen.generatePasswordRequested()
            }
        }
    }
}

            Label {
                text: "Website"
                color: Theme.textPrimary
            }

            TVTextField {
                id: websiteField
                Layout.fillWidth: true
            }

            Label {
                text: "Notes"
                color: Theme.textPrimary
            }

            TVTextField {
                id: notesField
                Layout.fillWidth: true
            }

            Item {
                Layout.fillHeight: true
            }

            TVButton {
                Layout.fillWidth: true
                text: "Save Changes"

                onClicked: {
                    editEntryScreen.saveChangesRequested(
                        titleField.text.trim(),
                        usernameField.text.trim(),
                        passwordField.text,
                        websiteField.text.trim(),
                        notesField.text.trim()
                    )
                }
            }
        }
    }
}