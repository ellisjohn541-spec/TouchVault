import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3

import "../components"
import "../style"

Item {
    id: openVaultScreen

    anchors.fill: parent

    signal backRequested()
    signal vaultSelected(string vaultName, string vaultPath)

    property var vaults: []

    function setVaults(newVaults) {
        vaults = newVaults || []
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
                text: "‹  Back"
                color: Theme.accent
                font.pixelSize: units.gu(2)

                MouseArea {
                    anchors.fill: parent
                    anchors.margins: -units.gu(1)

                    onClicked: {
                        openVaultScreen.backRequested()
                    }
                }
            }

            Label {
                text: "Open Existing Vault"
                color: Theme.textPrimary
                font.pixelSize: units.gu(3)
                font.bold: true
                Layout.fillWidth: true
            }

            Label {
                text: "Choose one of your saved vaults."
                color: Theme.textSecondary
                font.pixelSize: units.gu(1.7)
                Layout.fillWidth: true
            }

            TVDivider {
                Layout.fillWidth: true
            }

            /*
             * No vaults found
             */

            ColumnLayout {
                visible: openVaultScreen.vaults.length === 0

                Layout.fillWidth: true
                Layout.fillHeight: true

                spacing: units.gu(2)

                Item {
                    Layout.fillHeight: true
                }

                TVLogo {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: units.gu(8)
                    Layout.preferredHeight: units.gu(8)
                }

                Label {
                    text: "No vaults found"
                    color: Theme.textPrimary
                    font.pixelSize: units.gu(2.4)
                    font.bold: true
                    Layout.alignment: Qt.AlignHCenter
                }

                Label {
                    text: "Create a new vault first,\nthen it will appear here."
                    color: Theme.textSecondary
                    font.pixelSize: units.gu(1.7)
                    horizontalAlignment: Text.AlignHCenter
                    Layout.fillWidth: true
                }

                Item {
                    Layout.fillHeight: true
                }
            }

            /*
             * Vault list
             */

            ListView {
                id: vaultList

                visible: openVaultScreen.vaults.length > 0

                Layout.fillWidth: true
                Layout.fillHeight: true

                clip: true
                spacing: units.gu(1)

                model: openVaultScreen.vaults

                delegate: Rectangle {
                    width: vaultList.width
                    height: units.gu(7)

                    radius: Theme.radius
                    color: Theme.card

                    RowLayout {
                        anchors {
                            fill: parent
                            margins: units.gu(1.5)
                        }

                        Label {
                            text: modelData.name
                            color: Theme.textPrimary
                            font.pixelSize: units.gu(2)
                            font.bold: true
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "›"
                            color: Theme.accent
                            font.pixelSize: units.gu(2.5)
                        }
                    }

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            openVaultScreen.vaultSelected(
                                modelData.name,
                                modelData.path
                            )
                        }
                    }
                }
            }
        }
    }
}