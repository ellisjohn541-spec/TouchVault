import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: viewEntryScreen

    anchors.fill: parent

    signal backRequested()
    signal editRequested()
    signal deleteRequested()

    property string title: ""
    property string username: ""
    property string password: ""
    property string website: ""
    property string notes: ""

    property bool passwordVisible: false

    function setEntry(entry) {
        title = entry.title || ""
        username = entry.username || ""
        password = entry.password || ""
        website = entry.website || ""
        notes = entry.notes || ""
    }

    TextInput {
    id: usernameClipboard
    visible: false
}

TextInput {
    id: passwordClipboard
    visible: false
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

            RowLayout {
    Layout.fillWidth: true

    Label {
        text: "‹ Back"
        color: Theme.accent

        MouseArea {
            anchors.fill: parent
            anchors.margins: -units.gu(1)

            onClicked: {
                viewEntryScreen.backRequested()
            }
        }
    }

    Item {
        Layout.fillWidth: true
    }

    Label {
        text: "Edit"
        color: Theme.accent

        MouseArea {
            anchors.fill: parent
            anchors.margins: -units.gu(1)

            onClicked: {
                viewEntryScreen.editRequested()
            }
        }
    }
}

            Label {
                text: viewEntryScreen.title
                color: Theme.textPrimary
                font.pixelSize: units.gu(3)
                font.bold: true
                Layout.fillWidth: true
            }

            TVDivider {
                Layout.fillWidth: true
            }

            Label {
    text: "Username"
    color: Theme.textSecondary
}

RowLayout {
    Layout.fillWidth: true
    spacing: units.gu(1)

    Label {
        text: viewEntryScreen.username
        color: Theme.textPrimary
        font.pixelSize: units.gu(1.8)
        Layout.fillWidth: true
    }

    Label {
        text: "Copy"
        color: Theme.accent
        font.pixelSize: units.gu(1.6)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -units.gu(1)

            onClicked: {
                usernameClipboard.text = viewEntryScreen.username
                usernameClipboard.selectAll()
                usernameClipboard.copy()
                usernameClipboard.deselect()

                console.log("Username copied")
            }
        }
    }
}

            Label {
    text: "Password"
    color: Theme.textSecondary
}

RowLayout {
    Layout.fillWidth: true
    spacing: units.gu(1)

    Label {
        text: viewEntryScreen.passwordVisible
              ? viewEntryScreen.password
              : "••••••••••••"

        color: Theme.textPrimary
        font.pixelSize: units.gu(1.8)
        Layout.fillWidth: true
    }

    Label {
        text: viewEntryScreen.passwordVisible
              ? "Hide"
              : "Show"

        color: Theme.accent
        font.pixelSize: units.gu(1.6)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -units.gu(1)

            onClicked: {
                viewEntryScreen.passwordVisible =
                    !viewEntryScreen.passwordVisible
            }
        }
    }

    Label {
        text: "Copy"
        color: Theme.accent
        font.pixelSize: units.gu(1.6)

        MouseArea {
            anchors.fill: parent
            anchors.margins: -units.gu(1)

            onClicked: {
                passwordClipboard.text = viewEntryScreen.password
                passwordClipboard.selectAll()
                passwordClipboard.copy()
                passwordClipboard.deselect()

                console.log("Password copied")
            }
        }
    }
}

            Label {
                text: "Website"
                color: Theme.textSecondary
                visible: viewEntryScreen.website.length > 0
            }

            Label {
                text: viewEntryScreen.website
                color: Theme.textPrimary
                Layout.fillWidth: true
                visible: viewEntryScreen.website.length > 0
            }

            Label {
                text: "Notes"
                color: Theme.textSecondary
                visible: viewEntryScreen.notes.length > 0
            }

            Label {
                text: viewEntryScreen.notes
                color: Theme.textPrimary
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                visible: viewEntryScreen.notes.length > 0
            }

            Label {
    text: "Delete Password"
    color: Theme.error
    font.pixelSize: units.gu(1.6)
    Layout.alignment: Qt.AlignHCenter

    MouseArea {
        anchors.fill: parent
        anchors.margins: -units.gu(1)

        onClicked: {
            viewEntryScreen.deleteRequested()
        }
    }
}

            Item {
                Layout.fillHeight: true
            }
        }
    }
}