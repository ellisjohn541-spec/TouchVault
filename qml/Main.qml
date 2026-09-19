/*
 * Copyright (C) 2026 John Ellis
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * touchvault is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

import QtQuick 2.7
import Lomiri.Components 1.3
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import io.thp.pyotherside 1.4

MainView {
    id: root

    objectName: "mainView"
    applicationName: "touchvault.johnellis"
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    /*
     * Current vault session
     */

    property string currentVaultPath: ""
    property string currentVaultName: ""
    property string currentMasterPassword: ""
    property string currentEntryUuid: ""

    /*
     * Navigation
     */

    function showWelcome() {
        screenLoader.source =
            Qt.resolvedUrl("pages/WelcomeScreen.qml")
    }

    function showCreateVault() {
        screenLoader.source =
            Qt.resolvedUrl("pages/CreateVaultScreen.qml")
    }

    function showVault() {
        screenLoader.source =
            Qt.resolvedUrl("pages/VaultScreen.qml")
    }

    function showAddEntry() {
        screenLoader.source =
            Qt.resolvedUrl("pages/AddEntryScreen.qml")
    }

    function showEditEntry() {
    screenLoader.source =
        Qt.resolvedUrl("pages/EditEntryScreen.qml")
}

    function showOpenVault() {
        screenLoader.source =
            Qt.resolvedUrl("pages/OpenVaultScreen.qml")
    }

    function showUnlockVault() {
    screenLoader.source =
        Qt.resolvedUrl("pages/UnlockVaultScreen.qml")
    }

    function showEntry() {
    screenLoader.source =
        Qt.resolvedUrl("pages/ViewEntryScreen.qml")
    }

    function loadVaultList(callback) {
        var vaultDirectory =
            "/home/phablet/.local/share/" +
            "touchvault.johnellis/vaults"

        python.call(
            "vault.list_vaults",
            [vaultDirectory],
            function(result) {
                callback(result)
            }
        )
    }

    function shouldReturnToVault() {
    var source = screenLoader.source.toString()

    return source.indexOf("AddEntryScreen.qml") !== -1 ||
           source.indexOf("ViewEntryScreen.qml") !== -1
}

    function clearVaultSession() {
        currentVaultPath = ""
        currentVaultName = ""
        currentMasterPassword = ""
    }

    Rectangle {
        anchors.fill: parent
        color: "#121212"

        Loader {
            id: screenLoader

            anchors.fill: parent
            source: Qt.resolvedUrl("pages/WelcomeScreen.qml")

            onLoaded: {

                /*
                 * Pass vault name into screens that support it.
                 */

                if (item && item.vaultName !== undefined) {
                    item.vaultName = root.currentVaultName
                }

                /*
                 * Load password entries into VaultScreen.
                 */

                if (
                    item &&
                    item.setEntries &&
                    root.currentVaultPath.length > 0 &&
                    root.currentMasterPassword.length > 0
                ) {
                    var vaultScreenItem = item

                   python.call(
    "vault.list_entries",
    [
        root.currentVaultPath,
        root.currentMasterPassword
    ],
    function(result) {
        if (result.success) {
            vaultScreenItem.setEntries(
                result.entries
            )

            console.log(
                "Loaded entries: " +
                result.entries.length
            )
        } else {
            console.log(
                "Could not load entries: " +
                result.message
            )

            if (result.technical_error) {
                console.log(
                    "Backend detail: " +
                    result.technical_error
                )
            }
        }
    }
)
}

/*
 * Unlock existing vault.
 */

if (item && item.unlockRequested) {
    item.unlockRequested.connect(
        function(masterPassword) {
            var unlockScreenItem = item

            python.call(
                "vault.open_vault",
                [
                    root.currentVaultPath,
                    masterPassword
                ],
                function(result) {
                    if (result.success) {
                        root.currentMasterPassword =
                            masterPassword

                        root.showVault()
                    
                    } else {
                        unlockScreenItem.showUnlockResult(
                            false,
                            "Incorrect master password."
                        )

                        if (result.technical_error) {
                            console.log(
                                "Backend detail: " +
                                result.technical_error
                            )
                        }
                    }
                }
            )
        }
    )
}
                /*
                 * Load saved vaults into OpenVaultScreen.
                 */

                if (item && item.setVaults) {
                    var openVaultScreenItem = item

                    root.loadVaultList(function(result) {
                        if (result.success) {
                            openVaultScreenItem.setVaults(
                                result.vaults
                            )

                            console.log(
                                "Found vaults: " +
                                result.vaults.length
                            )
                        } else {
                            console.log(
                                "Could not load vault list: " +
                                result.message
                            )

                            if (result.technical_error) {
                                console.log(
                                    "Backend detail: " +
                                    result.technical_error
                                )
                            }
                        }
                    })
                }

                if (
    item &&
    item.setEntry &&
    root.currentEntryUuid.length > 0
) {
    var entryScreenItem = item

    python.call(
        "vault.get_entry",
        [
            root.currentVaultPath,
            root.currentMasterPassword,
            root.currentEntryUuid
        ],
        function(result) {
            if (result.success) {
                entryScreenItem.setEntry(result.entry)
            } else {
                console.log(
                    "Could not load entry: " +
                    result.message
                )

                if (result.technical_error) {
                    console.log(
                        "Backend detail: " +
                        result.technical_error
                    )
                }
            }
        }
    )
}

if (item && item.generatePasswordRequested) {
    item.generatePasswordRequested.connect(function() {
        var generatorScreen = item

        python.call(
            "vault.generate_password",
            [20],
            function(result) {
                if (result.success) {
                    generatorScreen.setGeneratedPassword(
                        result.password
                    )
                } else {
                    console.log(
                        "Password generation failed: " +
                        result.message
                    )
                }
            }
        )
    })
}

if (item && item.deleteRequested) {
    item.deleteRequested.connect(function() {
        python.call(
            "vault.delete_entry",
            [
                root.currentVaultPath,
                root.currentMasterPassword,
                root.currentEntryUuid
            ],
            function(result) {
                if (result.success) {
                    root.currentEntryUuid = ""
                    root.showVault()
                } else {
                    console.log(
                        "Could not delete entry: " +
                        result.message
                    )

                    if (result.technical_error) {
                        console.log(
                            "Backend detail: " +
                            result.technical_error
                        )
                    }
                }
            }
        )
    })
}

if (item && item.editRequested) {
    item.editRequested.connect(function() {
        root.showEditEntry()
    })
}

if (item && item.saveChangesRequested) {
    item.saveChangesRequested.connect(
        function(title, username, password, website, notes) {
            python.call(
                "vault.update_entry",
                [
                    root.currentVaultPath,
                    root.currentMasterPassword,
                    root.currentEntryUuid,
                    title,
                    username,
                    password,
                    website,
                    notes
                ],
                function(result) {
                    if (result.success) {
                        root.showEntry()
                    } else {
                        console.log(
                            "Could not update entry: " +
                            result.message
                        )

                        if (result.technical_error) {
                            console.log(
                                "Backend detail: " +
                                result.technical_error
                            )
                        }
                    }
                }
            )
        }
    )
}

                /*
                 * Welcome screen.
                 */

                if (item && item.createVaultRequested) {
                    item.createVaultRequested.connect(function() {
                        root.showCreateVault()
                    })
                }

                if (item && item.openVaultRequested) {
                    item.openVaultRequested.connect(function() {
                        root.showOpenVault()
                    })
                }

                /*
                 * Existing vault selection.
                 */

                if (item && item.vaultSelected) {
                    item.vaultSelected.connect(
                    function(vaultName, vaultPath) {

                    root.currentVaultName = vaultName
                    root.currentVaultPath = vaultPath

                    root.showUnlockVault()
                    })
                }

                /*
                 * Shared Back signal.
                 */

                if (item && item.backRequested) {
    item.backRequested.connect(function() {
        if (root.shouldReturnToVault()) {
            root.showVault()
        } else {
            root.showWelcome()
        }
    })
}

                /*
                 * Vault screen.
                 */

                if (item && item.lockRequested) {
                    item.lockRequested.connect(function() {
                        root.clearVaultSession()
                        root.showWelcome()
                    })
                }

                if (item && item.addEntryRequested) {
                    item.addEntryRequested.connect(function() {
                        root.showAddEntry()
                    })
                }

                if (item && item.entrySelected) {
    item.entrySelected.connect(
        function(entryUuid) {
            root.currentEntryUuid = entryUuid
            root.showEntry()
        }
    )
}

                /*
                 * Create vault.
                 */

                if (item && item.createRequested) {
                    item.createRequested.connect(
                        function(vaultName, masterPassword) {
                            var createScreenItem = item

                            var vaultDirectory =
                                "/home/phablet/.local/share/" +
                                "touchvault.johnellis/vaults"

                            python.call(
                                "vault.create_vault",
                                [
                                    vaultName,
                                    masterPassword,
                                    vaultDirectory
                                ],
                                function(result) {
                                    if (result.success) {
                                        root.currentVaultPath =
                                            result.path

                                        root.currentVaultName =
                                            vaultName

                                        root.currentMasterPassword =
                                            masterPassword
                                    }

                                    createScreenItem.showCreateResult(
                                        result.success,
                                        result.message
                                    )
                                }
                            )
                        }
                    )
                }

                if (item && item.vaultCreated) {
                    item.vaultCreated.connect(function() {
                        root.showVault()
                    })
                }

                /*
                 * Add password entry.
                 */

                if (item && item.saveEntryRequested) {
                    item.saveEntryRequested.connect(
                        function(
                            title,
                            username,
                            password,
                            website,
                            notes
                        ) {
                            python.call(
                                "vault.add_entry",
                                [
                                    root.currentVaultPath,
                                    root.currentMasterPassword,
                                    title,
                                    username,
                                    password,
                                    website,
                                    notes
                                ],
                                function(result) {
                                    console.log(
                                        "Save entry result: " +
                                        result.message
                                    )

                                    if (result.technical_error) {
                                        console.log(
                                            "Backend detail: " +
                                            result.technical_error
                                        )
                                    }

                                    if (result.success) {
                                        root.showVault()
                                    }
                                }
                            )
                        }
                    )
                }
            }
        }
    }

    Python {
        id: python

        Component.onCompleted: {
            addImportPath(Qt.resolvedUrl("../src/"))
            addImportPath(Qt.resolvedUrl("../python/"))

            importModule("vault", function() {
                console.log("TouchVault backend imported")
            })
        }

        onError: {
            console.log("Python error: " + traceback)
        }
    }
}