import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: vaultScreen

    anchors.fill: parent

    signal addEntryRequested()
    signal lockRequested()
    signal entrySelected(string uuid)

    property string searchText: ""
    property string vaultName: "Personal Vault"
    property var entries: []

    function setEntries(newEntries) {
        entries = newEntries || []
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

            RowLayout {
                Layout.fillWidth: true

                Label {
                    text: vaultScreen.vaultName
                    color: Theme.textPrimary
                    font.pixelSize: units.gu(3)
                    font.bold: true
                    Layout.fillWidth: true
                }

                Label {
                    text: "Lock"
                    color: Theme.accent
                    font.pixelSize: units.gu(1.8)

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -units.gu(1)

                        onClicked: {
                            vaultScreen.lockRequested()
                        }
                    }
                }
            }

            TVDivider {
                Layout.fillWidth: true
            }

            TVTextField {
    id: searchField

    Layout.fillWidth: true
    placeholderText: "Search passwords"

    onTextChanged: {
        vaultScreen.searchText = text.toLowerCase()
    }

    Label {
    text: "No matching passwords"

    color: Theme.textSecondary
    font.pixelSize: units.gu(1.7)

    Layout.alignment: Qt.AlignHCenter

    visible:
        vaultScreen.entries.length > 0 &&
        vaultScreen.searchText.length > 0 &&
        entryList.count === 0
}

    visible: vaultScreen.entries.length > 0
}

            /*
             * Empty vault view
             */

            ColumnLayout {
                visible: vaultScreen.entries.length === 0

                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: units.gu(2)

                Item {
                    Layout.fillHeight: true
                }

                TVLogo {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: units.gu(9)
                    Layout.preferredHeight: units.gu(9)
                }

                Label {
                    text: "Your vault is empty"
                    color: Theme.textPrimary
                    font.pixelSize: units.gu(2.5)
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "Your encrypted vault is ready.\n" +
                          "Add your first password to get started."

                    color: Theme.textSecondary
                    font.pixelSize: units.gu(1.7)
                    horizontalAlignment: Text.AlignHCenter
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                }

                TVButton {
                    Layout.fillWidth: true
                    text: "Add First Password"

                    onClicked: {
                        vaultScreen.addEntryRequested()
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            /*
             * Saved-entry list
             */

ListView {
    id: entryList

    visible: vaultScreen.entries.length > 0

    Layout.fillWidth: true
    Layout.fillHeight: true

    clip: true
    spacing: units.gu(1)

    model: {
    if (vaultScreen.searchText.length === 0) {
        return vaultScreen.entries
    }

    var filtered = []

    for (var i = 0; i < vaultScreen.entries.length; i++) {
        var entry = vaultScreen.entries[i]

        var title = (entry.title || "").toLowerCase()
        var username = (entry.username || "").toLowerCase()
        var website = (entry.website || "").toLowerCase()

        if (
            title.indexOf(vaultScreen.searchText) !== -1 ||
            username.indexOf(vaultScreen.searchText) !== -1 ||
            website.indexOf(vaultScreen.searchText) !== -1
        ) {
            filtered.push(entry)
        }
    }

    return filtered
}

    delegate: Rectangle {
        width: entryList.width
        height: units.gu(8)

        radius: Theme.radius
        color: Theme.card

        Column {
            anchors {
                fill: parent
                margins: units.gu(1.5)
            }

            spacing: units.gu(0.5)

            Label {
                text: modelData.title
                color: Theme.textPrimary
                font.pixelSize: units.gu(2)
                font.bold: true
            }

            Label {
                text: modelData.username
                color: Theme.textSecondary
                font.pixelSize: units.gu(1.6)
                visible: text.length > 0
            }

            Label {
                text: modelData.website
                color: Theme.textSecondary
                font.pixelSize: units.gu(1.4)
                visible: text.length > 0
            }
        }

        MouseArea {
            anchors.fill: parent

            onClicked: {
                console.log(
                    "Entry selected: " +
                    modelData.uuid
                )

                vaultScreen.entrySelected(
                    modelData.uuid
                )
            }
        }
    }
}

        TVButton {
            visible: vaultScreen.entries.length > 0

            Layout.fillWidth: true
            text: "Add Password"

            onClicked: {
                vaultScreen.addEntryRequested()
            }
        }
    }   // closes ColumnLayout
}       // closes Rectangle
}       // closes Item